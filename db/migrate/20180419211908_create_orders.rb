class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.string :creditcard
      t.string :name_on_card
      t.date :expiration_date
      t.string :cvv
      t.string :mail_address
      t.string :billing_address
      t.string :zipcode
      t.string :status

      t.timestamps
    end
  end
end
