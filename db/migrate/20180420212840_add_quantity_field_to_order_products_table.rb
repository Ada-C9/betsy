class AddQuantityFieldToOrderProductsTable < ActiveRecord::Migration[5.1]
  def change
    add_column :order_products, :quantity, :integer
  end
end
