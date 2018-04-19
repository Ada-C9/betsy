class CreateCategoryProductJoin < ActiveRecord::Migration[5.1]
  def change
    create_table :category_product do |t|
      t.belongs_to :product, index: true
      t.belongs_to :category, index: true
    end
  end
end
