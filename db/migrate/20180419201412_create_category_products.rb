class CreateCategoryProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :category_products do |t|

      t.timestamps
    end
  end
end
