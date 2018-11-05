class OrdersController < ApplicationController
	def index
		@orders = current_user.orders
	end

	def show
		@order = Order.find(params[:id]).includes(:billing_items)
	end

	def new
		@order = Order.new
		@addresses = current_user.addresses
	end

	def create
		order = current_user.orders.create address_id: params[:order][:address_id]
		order.add_billing_items
		flash[:success] = "Order placed"
		redirect_to order_path(order)
		# redirect_to :back
	end

	def show
		@order = current_user.orders.find(params[:id])
	end

	def destroy
		order = current_user.orders.find(params[:id])
		billing_items = order.billing_items.delete_all
		order.delete
		redirect_to orders_url
	end
end
