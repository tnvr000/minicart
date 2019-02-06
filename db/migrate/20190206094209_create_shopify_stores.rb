class CreateShopifyStores < ActiveRecord::Migration
  def change
    create_table :shopify_stores do |t|
    	t.string :name
    	t.string :token
      t.timestamps null: false
    end
  end
end
