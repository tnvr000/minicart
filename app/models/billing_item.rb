class BillingItem < ActiveRecord::Base
	belongs_to :product
	belongs_to :order

	validates :quantity, presence: true, numericality: {only_integer: true}
end
