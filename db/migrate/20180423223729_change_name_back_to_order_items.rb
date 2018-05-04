class ChangeNameBackToOrderItems < ActiveRecord::Migration[5.1]
  def change
    rename_table :items_order, :order_items
  end
end
