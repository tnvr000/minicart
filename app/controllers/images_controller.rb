class ImagesController < ApplicationController
	def index
		@images = Product.find(params[:product_id]).images
	end

	def new
		@image = @product = Product.find(params[:product_id])
		@image = @product.images.build
	end

	def create
		@product = Product.find(params[:product_id])
		@image = @product.images.build(image_params)
		if @image.save
			flash[:success] = "image added to product"
			redirect_to product_images_url(@product)
		else
			render 'new'
		end
	end

	def destroy
		@image = Image.find(params[:id]).destroy
		redirect_to product_images_url(@image.imageable)
	end

	def make_thumb
		@thumb_to_be = Image.find(params[:id])
		@old_thumb = @thumb_to_be.make_thumb
		# redirect_to product_images_url(@image.imageable)
	end

	private
	def image_params
		params.require(:image).permit([:image])
	end
end
