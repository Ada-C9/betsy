class CreateProductCategoryJoin < ActiveRecord::Migration[5.1]
  def change
    create_table :product_category do |t|
      t.belongs_to :product, index: true
      t.belongs_to :category, index: true
    end
  end
end
