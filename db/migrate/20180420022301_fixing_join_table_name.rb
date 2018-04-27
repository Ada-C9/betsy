class FixingJoinTableName < ActiveRecord::Migration[5.1]
  def change
    rename_table :product_category, :products_categories
  end
end
