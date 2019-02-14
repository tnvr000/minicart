class Shopify::MainController < ApplicationController
	after_action :set_frame_option
	layout 'layouts/shopify_app_layout'

	private
	def get_shopify_session
		shopify_session = ShopifyAPI::Session.new(@shop.name, @shop.token)
		ShopifyAPI::Base.activate_session(shopify_session)
		return shopify_session
	end

	def verify_shopify_webhooks
		hmac = request.env['HTTP_X_SHOPIFY_HMAC_SHA256']
		request.body.rewind
		data = request.body.read
		digest = OpenSSL::Digest.new('sha256')
		calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, API_SECRET_KEY, data)).strip

		if(!(ActiveSupport::SecurityUtils.secure_compare(hmac, calculated_hmac)))
			render nothing: true, status: 400 and return
		end
	end

	def authorize
		hmac = params[:hmac]
		hash = params.except(:hmac, :controller, :action, :id)
		query = hash.map{|key, value| "#{key}=#{value}"}.join('&')
		digest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), API_SECRET, query)

		unless ActiveSupport::SecurityUtils.secure_compare(hmac, digest)
			render nothing: true, status: 401 and return  #unauthorize
		end
	end

	def set_frame_option
		# Tells browser to allow iFrame to be rendered
		response.headers["X-Frame-Options"] = "allow-from https://#{@shop.name}" unless @shop.nil?
	end
end
