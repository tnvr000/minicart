module ProductsHelper
	def cart_item? product_id
		current_user.cart.cart_items.exists? product_id: product_id
	end
end
