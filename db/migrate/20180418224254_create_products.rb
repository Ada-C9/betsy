class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :review
      t.integer :rating
      t.string :name
      t.integer :stock
      t.float :price
      t.string :description

      t.timestamps
    end
  end
end
