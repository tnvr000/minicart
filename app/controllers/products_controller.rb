class ProductsController < ApplicationController
	def new
		# binding.pry
		@product = Product.new
	end

	def create
		# binding.pry
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
		@cart_item = current_user.cart.cart_items.build
	end

	def edit
		@product = Product.find(params[:id])
		@images = Image.new
	end

	def update
		flash[:warning] = "product redirecting back"
		redirect_to :back
	end

	private
	def product_params
		params.require(:product).permit(:name, :price, :category_id, :description)
	end
end
