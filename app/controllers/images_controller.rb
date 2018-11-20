class ImagesController < ApplicationController
	def index
		@product_id = params[:product_id]
		@images = Product.find_by_id(@product_id).images
	end

	def new
		@product = Product.find_by_id(params[:product_id])
		@image = @product.images.build
	end

	def create
		@product = Product.find_by_id(params[:product_id])
		@image = @product.images.build(image_params)
		if @image.save
			flash[:success] = "image added to product"
			redirect_to product_images_url(@product)
		else
			render 'new'
		end
	end

	def destroy
		@image = Image.find_by_id(params[:id]).destroy
		redirect_to product_images_url(@image.imageable)
	end

	def make_thumb
		@thumb_to_be = Image.find_by_id(params[:id])
		@old_thumb = @thumb_to_be.make_thumb
		# redirect_to product_images_url(@image.imageable)
	end

	private
	def image_params
		params.require(:image).permit([:image])
	end
end
