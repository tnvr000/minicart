class StandardPagesController < ApplicationController
	def index
		@categories = Category.all
		@products = {}
		# binding.pry
		@categories.each do |category|
			@products[category.name] = category.products.limit(10)
		end
	end
end
