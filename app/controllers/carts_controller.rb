class CartsController < ApplicationController
	def show
		@cart_items = current_user.cart.cart_items
	end
	def update
		current_user.cart.cart_items.create(product_id: params["cart"]["product_id"], quantity: 1)
		redirect_to cart_url(current_user.cart)
	end

end
