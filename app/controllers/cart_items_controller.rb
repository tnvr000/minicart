class CartItemsController < ApplicationController
	before_action :store_user_location!
	before_action :authenticate_user!

	def index
		@cart_items = current_user.cart.cart_items.includes(:product)
		@order = Order.new
	end

	def create
		@cart_item = current_user.cart.cart_items.build(cart_item_params)
		@cart_item.save
		redirect_to cart_items_url
	end

	def destroy
		@cart_item = CartItem.find(params[:id])
		@cart_item.delete
		respond_to do |format|
			format.html { redirect_to cart_items_path }
			format.js { render layout: false }
		end
	end

	def change_quantity
		# binding.pry
		@cart_item = current_user.cart.cart_items.find_by(id: params[:id])
		unless @cart_item.nil?
			quantity = update_qunatity(@cart_item)
			@cart_item.update_attribute(:quantity, quantity)
			@cart_item.quantity = quantity
		end
		respond_to do |format|
			format.html {redirect_to cart_items_path}
			format.js {render layout: false}
		end
		# redirect_to :back
	end

	private
	def cart_item_params
		params.require(:cart_item).permit(:product_id)
	end

	def update_qunatity cart_item
		quantity = cart_item.quantity
		if params[:dir] == 'minus'
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
