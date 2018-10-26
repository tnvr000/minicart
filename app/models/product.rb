class NameValidator < ActiveModel::EachValidator
	def validate_each record, attribute, value
		not_name = /([^0-9])/
		if value =~ not_name
			record.errors[attribute] = "can not contain numbers"
		end
	end
end
class Product < ActiveRecord::Base
	belongs_to :category
	validates :name, presence: true
	validates :description, presence: true
	validates :price, presence: true, numericality: {only_float: true}
end
