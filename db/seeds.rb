# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel', city: cities.first)
# Category.delete_all
# Product.delete_all
# User.delete_all
# Address.delete_all
# Order.delete_all
# BillingItem.delete_all


categories = []
categories << { name: "electronics" }
categories << { name: "men" }
categories << { name: "women" }
categories << { name: "baby & kids" }
categories << { name: "appliances" }
categories << { name: "home & furniture" }
categories << { name: "sports" }
Category.create(categories)
puts "created all categories"

Category.all.each do |category|
	thumb = File.open(File.join(Rails.root, 'public/system/rails.png'))
	img = File.open(File.join(Rails.root, 'public/system/avatar02.png'))
	20.times do
		pr = category.products.create(
			name: "#{Faker::Device.manufacturer} #{Faker::Device.model_name}",
			description: Faker::Lorem.sentence(20),
			price: Faker::Number.decimal(rand(3..5), 2)
			)
		puts "create product id: #{pr.id} for category: #{pr.category.name}"
		pr.images.create(image: thumb, default: true)
		puts "create thumb for product id #{pr.id}"
		pr.images.create(image: thumb, default: true)
		puts "create image for product id #{pr.id}"
	end
end

users = []
users << { name: "Tanveer Ahmad Khan",
					 email: "tnvr000@gmail.com",
					 contact_no: "8594976909",
					 password: "password"
					}
users << { name: "Tahir Ahmad Khan",
					 email: "tahirrockheart@gmail.com",
					 contact_no: "9453887151",
					 password: "password"
					}
users << { name: "Tarannum Ara",
					 email: "rikkisneha@gmail.com",
					 contact_no: "9889579786",
					 password: "password"
					}
users << { name: "Imteyaz Ahmad Khan",
					 email: "imteyaz588@gmail.com",
					 contact_no: "8825248586",
					 password: "password"
					}
User.create(users)
puts "created all users(#{User.all.count})"

User.all.each do |user|
	a = user.addresses.create(
		plot: "plot no. #{Faker::Address.building_number}",
		lane: Faker::Address.street_name,
		landmark: Faker::Address.community,
		city: Faker::Address.city,
		state: Faker::Address.state,
		pincode: Faker::Number.number(6),
		default: true
		)
	puts "created address id #{a.id}"

	5.times do
		order = user.orders.create(
			address_id: user.default_address.id
		)
		puts "created order id #{order.id}"
		3.times do
			pr = Product.find(rand(1..140))
			bi = order.billing_items.create(
				product_id: pr.id,
				quantity: rand(1..3),
				product_price: pr.price
			)
			puts "created billing item id: #{bi.id}"
		end
	end

	cart = user.create_cart
	puts "create cart id: #{cart.id}"
	5.times do 
		pr = Product.find(rand(1..140))
		ci = cart.cart_items.create(
			product_id: pr.id,
			quantity: rand(1..3)
		)
		puts "created cart item id: #{ci.id}"
	end
end
