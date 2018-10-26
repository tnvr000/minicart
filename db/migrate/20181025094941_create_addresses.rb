class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
    	t.string 	:plot
    	t.string 	:lane
    	t.string 	:landmark
    	t.string 	:city
    	t.string 	:state
    	t.integer	:pincode

    	t.integer	:user_id

      t.timestamps null: false
    end
  end
end
