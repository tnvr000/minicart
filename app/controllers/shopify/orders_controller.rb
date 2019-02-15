class Shopify::OrdersController < Shopify::MainController
	before_action :shopify_session
	def index
		@orders = ShopifyAPI::Order.find(:all)
	end

	def show
		@order = ShopifyAPI::Order.find(params[:id].to_i)
	end

	def edit
		@order = ShopifyAPI::Order.find(params[:id].to_i)
		@metafields = metafields
		# binding.pry
	end

	def update
		@order = ShopifyAPI::Order.find(params[:id].to_i)
		@metafields = metafields params['metafields']
		@metafields.each do |metafield|
			@order.add_metafield(metafield)
		end
		redirect_to shopify_shop_order_url(@shop, @order)
	rescue SocketError => e
		retry
	end

	private
	def metafields value={}
		metafields = @order.metafields
		keys = %w(length width height)
		dim_metafields = []
		parameters = {
			value_type: 'integer',
			namespace: 'dimension',
			owner_id: "#{@order.id}",
			owner_resource: 'order'
		}
		keys.each do |key|
			metafield = metafields.select{|metafield| metafield.key == key}.first
			(metafield.value = value[key] || metafield.value) and dim_metafields << metafield and next unless metafield.nil?
			parameters[:key] = key
			parameters[:value] = value[key] || '0'
			dim_metafields << ShopifyAPI::Metafield.new(parameters)
		end
		return dim_metafields
	end

	def shopify_session
		@shop = Shop.find_by_id params[:shop_id]
		get_shopify_session
	end

end
