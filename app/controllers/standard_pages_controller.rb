class StandardPagesController < ApplicationController
	def index
		@categories = Category.all
		@products = {}
		@categories.each do |category|
			@products[category.name] = category.products.limit(10)
		end
	end
end
