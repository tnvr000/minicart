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

	private
	def address_params
		params.require(:address).permit(:plot, :lane, :landmark, :city, :state, :pincode)
	end
end
