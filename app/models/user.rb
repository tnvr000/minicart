class User < ActiveRecord::Base
	has_one :address, dependent: :destroy
	has_many :orders, dependent: :destroy
end
