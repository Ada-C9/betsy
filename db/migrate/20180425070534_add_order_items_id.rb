class AddOrderItemsId < ActiveRecord::Migration[5.1]
  def change
    add_column :order_items, :id, :primary_key
  end
end
