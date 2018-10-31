class AddressesController < ApplicationController
	def create
		if current_user.address.nil?
			current_user.create_address(address_attributes)
		else
			current_user.address.update_attributes(address_attributes)
		end
		redirect_to user_path(current_user)
	end

	private
	def address_params
		params.require(:address).permit(:plot, :lane, :landmark, :city, :state, :pincode)
	end
	def address_attributes
		address_hash = {}
		address_hash[:plot] = params[:address][:plot]
		address_hash[:lane] = params[:address][:lane]
		address_hash[:landmark] = params[:address][:landmark]
		address_hash[:city] = params[:address][:city]
		address_hash[:state] = params[:address][:state]
		address_hash[:pincode] = params[:address][:pincode]
		address_hash
	end
end
