class Order < ActiveRecord::Base
	belongs_to :user
	has_one :address
	has_many :billing_items
	has_many :products, through: :billing_items
end
