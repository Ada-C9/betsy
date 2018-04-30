class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.string :description
      t.string :image
      t.integer :stock
      t.boolean :visible

      t.timestamps
    end
  end
end
