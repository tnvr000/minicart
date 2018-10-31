class AddDefaultQuantityToCartItem < ActiveRecord::Migration
  def up
  	change_column :cart_items, :quantity, :integer, default: 1
  end

  def down
  	change_column :cart_items, :quantity, :integer, default: nil
  end
end
