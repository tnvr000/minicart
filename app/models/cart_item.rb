class CartItem < ActiveRecord::Base
	belongs_to :cart
	belongs_to :product

	scope :with_id, ->(cart_item_id) {where('id = ?', cart_item_id).first}

end
