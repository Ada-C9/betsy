class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :email
      t.string :address
      t.string :card_name
      t.string :string
      t.string :cc_number
      t.date :cc_expiration
      t.string :cvv
      t.string :zip

      t.timestamps
    end
  end
end
