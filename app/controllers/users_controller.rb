class UsersController < ApplicationController
  def index
  end

  def show
  	# @user = current_user
  	@user = User.includes(:address).find_by(id: params[:id])
  	@address = current_user.address
  end

  def update
  end
end
