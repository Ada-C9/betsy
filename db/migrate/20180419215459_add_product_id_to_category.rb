class AddProductIdToCategory < ActiveRecord::Migration[5.1]
  def change
    add_reference :categories, :product, foreign_key: true
  end
end
