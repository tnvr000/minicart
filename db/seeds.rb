# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Catagory.delete_all
Product.delete_all
User.delete_all
Address.delete_all
Order.delete_all
BillingItem.delete_all

catagories = []
catagories << { name: "electronics" }
catagories << { name: "men" }
catagories << { name: "women" }
catagories << { name: "baby & kids" }
catagories << { name: "appliances" }
catagories << { name: "home & furniture" }
catagories << { name: "sports" }
Catagory.create(catagories)

Catagory.all.each do |catagory|
	20.times do
		catagory.products.create(
			name: "#{Faker::Device.manufacturer} #{Faker::Device.model_name}",
			description: Faker::Lorem.sentence(10),
			price: Faker::Number.decimal(rand(3..5), 2),
			)
	end
end

users = []
users << { name: "Tanveer Ahmad Khan",
					 email: "tnvr000@gmail.com",
					 contact_no: "8594976909"
					}
users << { name: "Tahir Ahmad Khan",
					 email: "tahirrockheart@gmail.com",
					 contact_no: "9453887151"
					}
users << { name: "Tarannum Ara",
					 email: "rikkisneha@gmail.com",
					 contact_no: "9889579786"
					}
users << { name: "Imteyaz Ahmad Khan",
					 email: "imteyaz588@gmail.com",
					 contact_no: "8825248586"
					}
User.create(users)

User.all.each do |user|
	user.create_address(
		plot: "plot no. #{Faker::Address.building_number}",
		lane: Faker::Address.street_name,
		landmark: Faker::Address.community,
		city: Faker::Address.city,
		state: Faker::Address.state,
		pincode: Faker::Number.number(6)
		)
end

User.all.each do |user|
	5.times do
		user.orders.create(
			address_id: user.address.id
		)
	end
end

Order.all.each do |order|
	3.times do
		order.billing_items.create(
			product_id: rand(1..140),
			quantity: rand(1...3)
		)
	end
end