class CartItemsController < ApplicationController
	def destroy
		cart_item = CartItem.find(params[:id])
		cart_item.delete
		redirect_to :back
	end
end
