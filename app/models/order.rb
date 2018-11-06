class Order < ActiveRecord::Base
	belongs_to :user
	belongs_to :address
	has_many :billing_items, dependent: :destroy
	has_many :products, through: :billing_items

	def add_billing_items
		cis = User.cart_items self.user_id
		bis = []
		cis.each do |ci|
			bis << {order_id: self.id,
							product_id: ci.product_id,
							quantity: ci.quantity,
							product_price: ci.product.price}
		end
		BillingItem.create(bis)
		cis.delete_all
	end

	# def address
	# 	Address.joins(:orders).where(addresses: {id: self.address_id})
	# end

end
