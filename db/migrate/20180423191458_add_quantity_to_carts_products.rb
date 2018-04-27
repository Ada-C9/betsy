class AddQuantityToCartsProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :carts_products, :quantity, :integer
  end
end
