class CartItemsController < ApplicationController
	before_action :store_user_location!
	before_action :authenticate_user!

	def index
		@cart_items = current_user.cart.cart_items.includes(:product)
		@order = Order.new
	end

	def create
		binding.pry
		current_user.cart.cart_items.create(cart_item_params)
		redirect_to cart_items_url
	end

	def destroy
		cart_item = CartItem.find(params[:id])
		cart_item.delete
		redirect_to :back
	end

	def change_quantity
		cart_item = current_user.cart.cart_items.with_id(params[:id])
		unless cart_item.nil?
			quantity = update_qunatity(cart_item, params[:dir])
			cart_item.update_attribute(:quantity, quantity)
		end
		redirect_to :back
	end

	private
	def cart_item_params
		params.require(:cart_item).permit(:product_id)
	end

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

	def store_user_location!
    store_location_for(:user, request.referer)
  end

  def after_sign_in_path_for resource
    stored_location_for(resource) || super
  end
end
