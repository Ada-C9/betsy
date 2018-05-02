class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.boolean :is_active
      t.text :description
      t.integer :price
      t.string :photo_url
      t.integer :stock

      t.timestamps
    end
  end
end
