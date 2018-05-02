class RenameCategoryProductsTabletoCategoriesProducts < ActiveRecord::Migration[5.1]
  def change
    rename_table :category_products, :categories_products
  end
end
