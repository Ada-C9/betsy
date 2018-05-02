class AddProductIDandCategoryIdToCategoryProduct < ActiveRecord::Migration[5.1]
  def change
    add_reference :category_products, :product, foreign_key: true
    add_reference :category_products, :category, foreign_key: true
  end
end
