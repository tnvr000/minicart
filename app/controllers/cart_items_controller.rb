class CartItemsController < ApplicationController
	def change_quantity
		cart_item = @cart.cart_items.with_id(params[:id])
		unless cart_item.nil?
			quantity = update_qunatity(cart_item, params[:dir])
			cart_item.update_attribute(:quantity, quantity)
		end
		redirect_to :back
	end
	def destroy
		cart_item = CartItem.find(params[:id])
		cart_item.delete
		redirect_to :back
	end

	private
	def update_qunatity cart_item, direction
		quantity = cart_item.quantity
		if direction == 'minus'
			if quantity > 1
				quantity - 1
			else
				quantity
			end
		else
			quantity + 1
		end
	end
end
