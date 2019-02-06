require 'net/http'
require 'uri'
class WebhooksController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :verify_shopify_request, only: [:shipping_rates]
	def install
		shop = params[:shop]
		scopes = "read_orders,read_products,write_products,write_shipping,write_fulfillments"

		install_url = build_install_url shop, scopes
		redirect_to install_url
	end

	def auth
		shop = params[:shop]
		code = params[:code]
		hmac = params[:hmac]

		if(!authorize(hmac))
			render nothing: true, status: 404 and return
		end
		response = permanent_access_token shop, code
		if(response.message == 'OK')
			token = JSON.parse(response.body)["access_token"]
			puts token
			create_carrier_service token
			# create_fulfillment_service token
			create_webhooks token
		else
			render html: response.body.html_safe and return
		end
		render nothing: true
	end

	def shipping_rates
		response = {
			"rates": 
			[
				{
					"service_name": "canadapost-overnight",
					"service_code": "ON",
					"total_price": "1295",
					"description": "This is the fastest option by far",
					"currency": "CAD",
					"min_delivery_date": "2013-04-12 14:48:45 -0400",
					"max_delivery_date": "2013-04-12 14:48:45 -0400"
				}
			]
		}
		render json: response.to_json
	end

	def order_created
		puts params
		# binding.pry
		render nothing: true, status: 200
	end

	private
	def build_install_url shop, scopes
		install_url = "http://#{shop}/admin/oauth/authorize"
		install_url += "?client_id=#{API_KEY}"
		install_url += "&scope=#{scopes}"
		install_url += "&redirect_uri=https://#{APP_URL}/webhooks/auth"
		# install_url += "&nonce=#{NONCE}"
	end

	def permanent_access_token shop, code
		access_token_url = "https://#{shop}/admin/oauth/access_token"
		query = {
			client_id: API_KEY,
			client_secret: API_SECRET_KEY,
			code: code
		}
		res = Net::HTTP.post(URI(access_token_url), query.to_json, "Content-Type" => "application/json")
	end

	def create_carrier_service token
		create_carrier_service_url = URI("https://#{SHOP}/admin/carrier_services.json")
		query = {
  		"carrier_service" => {
    		"name" => "AllPro Shipping Rate Provider",
    		"callback_url" => "http://#{APP_URL}/webhooks/shipping_rates",
    		"service_discovery" => true
    	}
  	}
  	headers = {
  		"Accept" => "application/json",
  		"Content-Type" => "application/json",
  		"X-Shopify-Access-Token" => "#{token}"
  	}
  	res = Net::HTTP.post(create_carrier_service_url, query.to_json, headers)
  	puts res.body
	end

	def create_fulfillment_service token
		create_fulfillment_service_url = URI("https://#{SHOP}/admin/fulfillment_services.json")
		query = {
			"fulfillment_service": {
				"name": "AllProFulfillment",
				"callback_url": "http://#{APP_URL}/webhooks/fulfillment_service",
				"inventory_management": true,
				"tracking_support": true,
				"requires_shipping_method": true,
				"format": "json"
			}
		}
		headers = {
			"Accept" => "application/json",
			"Content-Type" => "application/json",
			"X-Shopify-Access-Token" => "#{token}"
		}
		res = Net::HTTP.post(create_fulfillment_service_url, query.to_json, headers)
		puts res.body
	end

	def create_webhooks token
		uri = URI("https://#{SHOP}/admin/webkooks.json")
		headers = {
			"Accept" => "application/json",
			"Content-Type" => "application/json",
			"X-Shopify-Access-Token" => "#{token}"
		}
		create_order_created_webhook uri, headers
	end

	def create_order_created_webhook uri, headers
		query = {
			webkook: {
				topic: "orders/create",
				address: "https://#{APP_URL}/webhooks/order_created",
				format: "json"
			}
		}
		res = Net::HTTP.post(uri, query.to_json, headers)
		puts res.body
	end

	def authorize hmac
		hash = params.reject{|key, value| key == 'hmac' || key == 'controller' || key == 'action'}
		query = URI.escape(hash.sort.map{|key, value| "#{key}=#{value}"}.join('&'))
		digest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), API_SECRET_KEY, query)
		
		ActiveSupport::SecurityUtils.secure_compare(hmac, digest)
	end

	def verify_shopify_request
		hmac = request.env['HTTP_X_SHOPIFY_HMAC_SHA256']
		request.body.rewind
		data = request.body.read
		digest = OpenSSL::Digest.new('sha256')
		calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, API_SECRET_KEY, data)).strip

		if(!(ActiveSupport::SecurityUtils.secure_compare(hmac, calculated_hmac)))
			render nothing: true, status: 403
		end
	end
end