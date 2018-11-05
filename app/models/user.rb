class NameValidator < ActiveModel::EachValidator
	def validate_each record, attribute, value
		name_regex = /([^0-9])/
		unless value =~ name_regex
			record.errors[attribute] = "can not contain numbers"
		end
	end
end
class EmailValidator < ActiveModel::EachValidator
	def validate_each record, attribute, value
		v = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
		unless value =~ v
			record.errors[attribute] = "not an email"
		end
	end
end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy
	has_one :cart, dependent: :destroy
	has_many :orders, dependent: :destroy

	# validates :name, presence: true, name: true
	# validates :email, presence: true, email: true
	validates :contact_no, presence: true, numericality: true

	def self.cart_items user_id
		cart_items = User.find(user_id).cart.cart_items.includes(:product)
	end

end
