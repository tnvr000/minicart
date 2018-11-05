class Address < ActiveRecord::Base
	belongs_to :user

	validates :plot, presence: true
	validates :lane, presence: true
	validates :city, presence: true
	validates :state, presence: true
	validates :pincode, presence: true, numericality: true, length: {is: 6}

	def make_default
		old_default_address = self.user.default_address
		old_default_address.update_attributes(default: false)
		self.update_attributes(default: true)
	end

end
