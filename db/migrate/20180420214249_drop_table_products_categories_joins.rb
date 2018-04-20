class DropTableProductsCategoriesJoins < ActiveRecord::Migration[5.1]
  def up
    drop_table :products_categories_joins
  end
  def down
    create_table "products_categories_joins", force: :cascade do |t|
      t.bigint "product_id"
      t.bigint "category_id"
      t.index ["category_id"], name: "index_products_categories_joins_on_category_id"
      t.index ["product_id"], name: "index_products_categories_joins_on_product_id"
    end
  end
end
