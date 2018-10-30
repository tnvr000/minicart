class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :create_cart

  private
  # binding.pry
  def create_cart
  	if @cart.nil?
  		if user_signed_in?
  			@cart = current_user.cart
  			@no_of_cart_items = @cart.cart_items.count
  		else
  			@cart = Cart.new
  			@no_of_cart_items = 0
  		end
  	end
  end
end
