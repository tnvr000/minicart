class AddDefaultToAddresses < ActiveRecord::Migration
  def up
  	add_column :addresses, :default, :boolean, default: false
  end
end
