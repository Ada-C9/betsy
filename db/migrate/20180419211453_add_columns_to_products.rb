class AddColumnsToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :name, :string
    add_column :products, :stock, :integer
    add_column :products, :price, :integer
    add_column :products, :description, :string
  end
end
