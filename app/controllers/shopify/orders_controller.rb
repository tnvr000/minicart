class Shopify::OrdersController < Shopify::MainController
	# before_action :authorize
	def index
		@shop = Shop.find_by_id(params[:shop_id])
		shopify_session = get_shopify_session
		@orders = ShopifyAPI::Order.find(:all)
	end

	def show
		@shop = Shop.find_by_id(params[:shop_id])
		shopify_session = get_shopify_session
		@order = ShopifyAPI::Order.find(params[:id].to_i)
	end

	def edit
		@shop = Shop.find_by_id(params[:shop_id])
		shopify_session = get_shopify_session
		@order = ShopifyAPI::Order.find(params[:id].to_i)
	end
end
