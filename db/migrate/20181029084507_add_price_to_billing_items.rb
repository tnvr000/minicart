class AddPriceToBillingItems < ActiveRecord::Migration
  def change
  	add_column :billing_items, :product_price, :float
  end
end
