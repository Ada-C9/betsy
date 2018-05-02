class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.string :description
      t.integer :stock
      t.boolean :discontinued
      t.string :photo

      t.timestamps
    end
  end
end
