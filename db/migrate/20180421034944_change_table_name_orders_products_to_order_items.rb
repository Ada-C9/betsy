class ChangeTableNameOrdersProductsToOrderItems < ActiveRecord::Migration[5.1]
  def change
    rename_table :orders_products, :OrderItems
  end
end
