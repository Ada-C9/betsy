class EditTableContents < ActiveRecord::Migration[5.1]
  def change
    add_reference :cart_items, :product, foreign_key: true
    rename_table :prducts_categories, :products_categories 
  end
end
