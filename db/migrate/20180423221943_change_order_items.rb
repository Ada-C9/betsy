class ChangeOrderItems < ActiveRecord::Migration[5.1]
  def change
    rename_table :order_items, :items_order
  end
end
