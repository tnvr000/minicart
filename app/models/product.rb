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
	has_many :images, as: :imageable, class_name: "Image", dependent: :destroy
	has_one :thumb, -> {where(images: {default: true})}, class_name: "Image", foreign_key: "imageable_id"

	accepts_nested_attributes_for :images, allow_destroy: true

	scope :of_category, ->(category_id) {where("category_id = ?", category_id)}
	scope :of_similar_price, ->(price) {where("price > ? and price < ?", price - price * 0.25, price + price * 0.25)}
	scope :excluding, ->(product_id) {where('id != ?', product_id)}

	validates :name, presence: true
	validates :description, presence: true
	validates :price, presence: true, numericality: {only_float: true}

	def related_products
		Product.of_category(self.category_id).of_similar_price(self.price).excluding(self.id)
	end


	def self.to_a
		puts self.superclass.superclass
	end

	def self.process_ajax args
		product = Product.all

		args['iSortingCols'].to_i.times.with_index do |i|
			order_by_col = args["mDataProp_#{args["iSortCol_#{i}"]}"]
			order_by_dir = args["sSortDir_#{i}"].upcase
			product = product.order("#{order_by_col} #{order_by_dir}")
		end

		unless (key = args['sSearch']).blank?
			condition = ""
			args['iColumns'].to_i.times.with_index do |i|
				col = args["mDataProp_#{i}"]
				condition += "OR #{col} LIKE '%#{key}%'" if args["bSearchable_#{i}"] == "true"
			end
			product = product.where(condition.sub('OR ', '')) unless condition.blank?
		end

		total_record = product.size
		product = product.offset(args['iDisplayStart'].to_i) unless args['iDisplayStart'].blank?
		product = product.limit(args['iDisplayLength'].to_i) unless args['iDisplayLength'].blank?
		return product, total_record
	end

end
	# def self.for_data_table
	# 	products_array = []
	# 	products = Product.all
	# 	products.each do |product|
	# 		product_data = []
	# 		product.attributes.each do |key, value|
	# 			product_data << value.to_s
	# 		end
	# 		products_array << product_data
	# 	end
	# 	return products_array
	# end
