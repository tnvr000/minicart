class UsersController < ApplicationController
  def index
  end

  def show
  	@user = User.includes(:default_address).find_by(id: params[:id])
  end

  def update
  end
end
