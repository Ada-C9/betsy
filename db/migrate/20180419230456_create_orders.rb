class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :name
      t.string :email
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :name_cc
      t.string :credit_card
      t.date :expiry
      t.string :ccv
      t.string :billing_zip

      t.timestamps
    end
  end
end
