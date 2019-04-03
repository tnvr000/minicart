class Shopify::ProductsController < Shopify::MainController
	def index
		@shop = Shop.find_by_id params[:shop_id]
		shopify_session = get_shopify_session
		@products = ShopifyAPI::Product.find(:all)
	rescue SocketError => e
		retry
	end

	def edit
		@shop = Shop.find_by_id params[:shop_id]
		shopify_session = get_shopify_session
		@product = ShopifyAPI::Product.find(params[:id].to_i)
	rescue
		retry
	end
end
