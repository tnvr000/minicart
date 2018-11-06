module OrdersHelper
	def billing_item_names_in order
		products_name = ""
		order.billing_items.each do |billing_item|
			products_name = products_name + billing_item.product.name + "\n"
		end
		products_name
	end

end
