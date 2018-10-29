class ProductsController < ApplicationController
	def show
		@product = Product.find(params[:id])
		@related_products = @product.related_products
	end
end
