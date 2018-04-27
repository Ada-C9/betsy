class ChangeOrderItemToOrdersItems < ActiveRecord::Migration[5.1]
  def change
    rename_table :order_item, :items_orders
  end
end
