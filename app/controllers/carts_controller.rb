class CartsController < ApplicationController
	def show
		@cart_items = @cart.cart_items
	end
	def update
		# binding.pry
		@cart.cart_items.create(product_id: params["cart"]["product_id"], quantity: 1)
		@no_of_cart_items = @cart.cart_items.count
		redirect_to cart_url(@cart)
	end

end
