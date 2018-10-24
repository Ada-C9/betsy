class AddProductStatusToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :product_status, :string
  end
end
