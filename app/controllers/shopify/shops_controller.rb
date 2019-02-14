class Shopify::ShopsController < Shopify::MainController
	skip_before_action :verify_authenticity_token, only: [:index, :auth]
	before_action :authorize, only: [:index, :auth]
	# #BA - authorize
	def index
		@shop = Shop.find_or_initialize_by name: params[:shop]
		ShopifyAPI::Session.setup(api_key: API_KEY, secret: API_SECRET)
		shopify_session = ShopifyAPI::Session.new(@shop.name)
		if @shop.token.nil?
			redirect_uri = "https://#{APP_URL}/shopify/shops/auth"
			redirect_to session.create_permission_url(SCOPES, redirect_uri) and return
		end
		ShopifyAPI::Base.activate_session(shopify_session)
		redirect_to shopify_shop_url(@shop)
	end

	def auth
		binding.pry
		@shop = Shop.find_or_initialize_by(name: params[:shop])
		if @shop.token.nil?
			@shop.token = permanent_access_token
			@shop.save
		end
		redirect_to shopify_shops_path request.parameters
	end

	def show
		@shop = Shop.find_by_id params[:id]
		shopify_session = get_shopify_session
		@current_shop = shopify_session.shop
	end

	private
	def permanent_access_token
		session = ShopifyAPI::Session.new(@shop.name)
		token = session.request_token(params)
	end

end
