class Order < ActiveRecord::Base
	belongs_to :user
	has_one :address
	has_many :billing_items, dependent: :destroy
	has_many :products, through: :billing_items
end
