class CreateProductsCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :products_categories do |t|
      t.integer :quantity

      t.timestamps
    end
  end
end
