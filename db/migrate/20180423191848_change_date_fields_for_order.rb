class ChangeDateFieldsForOrder < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :expiration_date
    add_column :orders, :expiration_month, :date
    add_column :orders, :expiration_year, :date
  end
end
