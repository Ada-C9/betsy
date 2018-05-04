class ChangeDefaultColumnOrders < ActiveRecord::Migration[5.1]
  def change
    change_column_default :orders, :status, "pending"
  end
end
