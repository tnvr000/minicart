class Address < ActiveRecord::Base
	belongs_to :user

	validates :plot, presence: true
	validates :lane, presence: true
	validates :city, presence: true
	validates :state, presence: true
	validates :pincode, presence: true, numericality: true, length: {is: 6}
end
