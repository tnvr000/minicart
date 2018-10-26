class StandardPagesController < ApplicationController
	def index
		@categories = Category.all
		@products = {}
		byebug
		@categories.each do |category|
			@products[category.name] = category.products.limit(5)
		end
	end
end
