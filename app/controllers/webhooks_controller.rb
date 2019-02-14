require 'net/http'
require 'uri'
class WebhooksController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :verify_shopify_request, except: [:install, :index, :auth]
	after_action :set_frame_option

	layout 'shopify_app_layout'

	def index
		shop = params[:shop]
		@shop = ShopifyStore.find_or_initialize_by(:name=>shop)
		if @shop.token.nil?
			scopes = "read_orders,read_products,write_products,write_shipping,write_fulfillments"

			install_url = build_install_url scopes
			redirect_to install_url and return
		end
	end

	def install
		shop = params[:shop]
		@shop = ShopifyStore.find_or_initialize_by(:name=>shop)
		if @shop.token.nil?
			scopes = "read_orders,read_products,write_products,write_shipping,write_fulfillments"

			install_url = build_install_url scopes
			redirect_to install_url and return
		end
		session = ShopifyAPI::Session.new(@shop.name, @shop.token)
		ShopifyAPI::Base.activate_session(session)
		@orders = ShopifyAPI::Order.find(:all)
		# @orders.first.attributes.each do |attribute, value|
		# 	puts "#{attribute} = #{value}(#{value.class})"
		# end
	end

	def auth
		shop = params[:shop]
		code = params[:code]
		hmac = params[:hmac]
		@shop = ShopifyStore.find_or_initialize_by(:name=>shop)

		if(!authorize(hmac))
			render nothing: true, status: 400 and return
		end
		if @shop.token.nil?
			response = permanent_access_token code
			if(response.message == 'OK')
				@shop.token = JSON.parse(response.body)["access_token"]
				render nothing: true, status: 500 unless @shop.save
			else
				render html: response.body.html_safe and return
			end
		end
		create_carrier_service
		render nothing: true, status: 200
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
		render nothing: true, status: 200
	end

	def app_uninstalled
		shop = params[:name] + ".myshopify.com"
		@shop = ShopifyStore.find_by_name(shop)
		puts shop, @shop
		@shop.delete unless @shop.nil?
		render nothing: true, status: 200
	end

	private
	def build_install_url scopes
		install_url = "http://#{@shop.name}/admin/oauth/authorize"
		install_url += "?client_id=#{API_KEY}"
		install_url += "&scope=#{scopes}"
		install_url += "&redirect_uri=https://#{APP_URL}/webhooks/auth"
		# install_url += "&nonce=#{NONCE}"
	end

	def permanent_access_token code
		access_token_url = "https://#{@shop.name}/admin/oauth/access_token"
		query = {
			client_id: API_KEY,
			client_secret: API_SECRET,
			code: code
		}
		res = Net::HTTP.post(URI(access_token_url), query.to_json, "Content-Type" => "application/json")
	end

	def set_frame_option
		response.headers["X-Frame-Options"] = "allow-from https://#{@shop.name}" unless @shop.nil?
	end

	def create_carrier_service
		create_carrier_service_url = URI("https://#{@shop.name}/admin/carrier_services.json")
		query = {
  		"carrier_service" => {
    		"name" => "minicart Rate Provider",
    		"callback_url" => "http://#{APP_URL}/webhooks/shipping_rates",
    		"service_discovery" => true
    	}
  	}
  	headers = {
  		"Accept" => "application/json",
  		"Content-Type" => "application/json",
  		"X-Shopify-Access-Token" => "#{@shop.token}"
  	}
  	res = Net::HTTP.post(create_carrier_service_url, query.to_json, headers)
  	puts res.body
	end

	def create_fulfillment_service
		create_fulfillment_service_url = URI("https://#{SHOP}/admin/fulfillment_services.json")
		query = {
			"fulfillment_service": {
				"name": "minicart Fulfillment",
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
			"X-Shopify-Access-Token" => "#{@shop.token}"
		}
		res = Net::HTTP.post(create_fulfillment_service_url, query.to_json, headers)
		puts res.body
	end

	def create_webhooks
		uri = URI("https://#{@shop.name}/admin/webhooks.json")
		headers = {
			"Accept" => "application/json",
			"Content-Type" => "application/json",
			"X-Shopify-Access-Token" => "#{@shop.token}"
		}
		create_order_created_webhook uri, headers
		create_app_uninstall_webhook uri, headers
	end

	def create_order_created_webhook uri, headers
		query = {
			"webhook" => {
				"topic" => "orders/create",
				"address" => "https://#{APP_URL}/webhooks/order_created",
				"format" => "json"
			}
		}
		res = Net::HTTP.post(uri, query.to_json, headers)
		puts res
	end

	def create_app_uninstall_webhook uri, headers
		query = {
			webhook: {
				topic: "app/uninstalled",
				address: "https://#{APP_URL}/webhooks/app_uninstalled",
				format: "json"
			}
		}
		res = Net::HTTP.post(uri, query.to_json, headers)
		puts res
	end

	def authorize hmac
		hash = params.except(:hmac, :controller, :action)
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
			render nothing: true, status: 400 and return
		end
	end
end