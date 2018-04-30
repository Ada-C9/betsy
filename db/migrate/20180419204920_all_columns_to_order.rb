class AllColumnsToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :date, :date
    add_column :orders, :status, :string
    add_column :orders, :name, :string
    add_column :orders, :email, :string
    add_column :orders, :address, :string
    add_column :orders, :cc_num, :string
    add_column :orders, :expiry_date, :date
    add_column :orders, :cc_cvv, :string
    add_column :orders, :zip, :string
  end
end
