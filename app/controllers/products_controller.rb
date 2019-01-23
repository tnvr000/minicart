class ProductsController < ApplicationController
	def new
		@product = Product.new
	end

	def create
		@product = Product.new(product_params)
		if @product.save
			redirect_to product_url(@product)
		else
			render 'new'
		end
	end

	def show
		# binding.pry
		@product = Product.find(params[:id])
		@thumb = @product.thumb
		@related_products = @product.related_products.includes(:thumb)
		@cart_item = user_signed_in? ? current_user.cart.cart_items.build : CartItem.new
	end

	def edit
		@product = Product.find(params[:id])
		@images = Image.new
	end

	def update
		flash[:warning] = "product redirecting back"
		redirect_to :back
	end

	def products_tables
		# @products = Product.includes(:category, :images).all
		respond_to do |format|
			format.json do
				# binding.pry
				if params["sEcho"].blank?
					@products = Product.includes(:category, :images).all
					total_records = Product.all.count
				else
					@products, total_records = Product.includes(:category, :images).process_ajax params
				end
				data = {}
				data['iTotalRecords'] = total_records
				data['iTotalDisplayRecords'] = total_records
				data["aaData"] = @products.as_json(include: [{category: {only: [:name]}}, {images: {only: [:id]}}])
				# binding.pry
				render json: data
			end
			format.html do
				@products = Product.includes(:category, :images).all
			end
		end
	end

	def newWI
		@product = Product.includes(:images).new
	end

	def createWI
		binding.pry
		@product = Product.includes(:images).new(productWI_params)
		if @product.save
			redirect_to product_path(@product)
		else
			render 'newWI'
		end
	end

	def shopify
		
	end

	private
	def product_params
		params.require(:product).permit(:name, :price, :category_id, :description)
	end

	def productWI_params
		params.require(:product).permit(:name, :price, :category_id, :description, images_attributes: [:id, :image, :thumb, :_destroy, ])
	end
end
