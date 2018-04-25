class DropCategoriesProduct < ActiveRecord::Migration[5.1]
  def change
    drop_table :categories_products do |t|
      t.bigint "product_id", null: false
      t.bigint "category_id", null: false
      t.timestamps null: false
    end
  end
end
