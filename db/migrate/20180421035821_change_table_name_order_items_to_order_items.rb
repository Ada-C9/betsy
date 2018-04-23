class ChangeTableNameOrderItemsToOrderItems < ActiveRecord::Migration[5.1]
  def change
    rename_table :OrderItems, :order_items
  end
end
