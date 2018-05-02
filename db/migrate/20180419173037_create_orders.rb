class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :email_address
      t.string :mailing_address
      t.string :cc_name
      t.integer :cc_number
      t.integer :cc_exp
      t.integer :cc_cvv
      t.integer :cc_zip
      t.string :status

      t.timestamps
    end
  end
end
