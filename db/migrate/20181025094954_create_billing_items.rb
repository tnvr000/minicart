class CreateBillingItems < ActiveRecord::Migration
  def change
    create_table :billing_items do |t|
    	t.integer		:product_id
    	t.integer 	:order_id
    	t.integer		:quantity

      t.timestamps null: false
    end
  end
end
