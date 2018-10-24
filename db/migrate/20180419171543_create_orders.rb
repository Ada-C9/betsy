class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :state
      t.string :email
      t.string :name
      t.string :ccnumber
      t.date :ccexpiration
      t.string :cvv
      t.string :address
      t.string :zipcode

      t.timestamps
    end
  end
end
