class AddColumnsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :email, :string
    add_column :orders, :mail_adr, :string
    add_column :orders, :cc_name, :string
    add_column :orders, :cc_num, :string
    add_column :orders, :cc_exp, :string
    add_column :orders, :cc_cvv, :string
    add_column :orders, :bill_zip, :string
  end
end
