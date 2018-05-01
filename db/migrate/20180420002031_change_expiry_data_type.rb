class ChangeExpiryDataType < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :date, :timestamp
    change_column :orders, :expiry_date, :string
  end
end
