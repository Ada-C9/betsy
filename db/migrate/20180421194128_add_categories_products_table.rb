class AddCategoriesProductsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :categories_products do |t|
      t.bigint :category_id
      t.bigint :product_id
      t.integer :quantity
    end
  end
end
