class AddressesController < ApplicationController
	def index
		@addresses = current_user.addresses
	end

	def new
		@address = Address.new
	end

	def create
		@address = current_user.addresses.build(address_params)
		if @address.save
			redirect_to user_path(current_user)
		else
			render 'new'
		end
	end

	def edit
		@address = current_user.addresses.find(params[:id])
	end

	def update
		address = current_user.addresses.find(params[:id])
		address.update_attributes(address_params)
		redirect_to addresses_url
	end

	def destroy
		current_user.addresses.find(params[:id]).destroy
		redirect_to addresses_url
	end

	def make_default
		address = current_user.addresses.find(params[:id])
		address.make_default
		redirect_to addresses_url
	end

	private
	def address_params
		params.require(:address).permit(:plot, :lane, :landmark, :city, :state, :pincode)
	end
end
