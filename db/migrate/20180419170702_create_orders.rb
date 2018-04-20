class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :status
      t.integer :cc_num
      t.integer :cvv
      t.string :email
      t.string :street_address
      t.string :state
      t.string :city
      t.integer :zip

      t.timestamps
    end
  end
end
