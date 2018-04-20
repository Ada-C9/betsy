class CreateProductsCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories_products do |t|
      t.bigint "product_id"
      t.bigint "category_id"
      t.index ["category_id"], name: "index_products_categories_on_category_id"
      t.index ["product_id"], name: "index_products_categories_on_product_id"
    end
  end
end
