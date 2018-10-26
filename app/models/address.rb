class NameValidator < ActiveModel::EachValidator
	def validate_each record, attribute, value
		not_name = /([^0-9])/
		if value =~ not_name
			record.errors[attribute] = "can not contain numbers"
		end
	end
end

class Address < ActiveRecord::Base
	belongs_to :user

	validates :plot, presence: true
	validates :lane, presence: true
	validates :city, presence: true, name: true
	validates :state, presence: true, name: true
	validates :pincode, presence: true, numericality: true, length: {is: 6}
end
