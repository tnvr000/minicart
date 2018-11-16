class ProductsController < ApplicationController
	def new
		@product = Product.new
	end

	def create
		@product = Product.new(product_params)
		if @product.save
			redirect_to product_url(@product)
		else
			render 'new'
		end
	end

	def show
		@product = Product.find(params[:id])
		@thumb = @product.thumb
		@related_products = @product.related_products
		@cart_item = user_signed_in? ? current_user.cart.cart_items.build : CartItem.new
	end

	def edit
		@product = Product.find(params[:id])
		@images = Image.new
	end

	def update
		flash[:warning] = "product redirecting back"
		redirect_to :back
	end

	def products_tables
		@products = Product.includes(:category, :images).all
		respond_to do |format|
			format.json do
				data = {}
				data["aaData"] = @products.as_json(include: [{category: {only: [:name]}}, {images: {only: [:id]}}])
				# binding.pry
				# data = Product.for_data_table
				render json: data
			end
			format.html
		end
	end

	private
	def product_params
		params.require(:product).permit(:name, :price, :category_id, :description)
	end
end
