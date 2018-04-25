class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :stock
      t.integer :price
      t.string :description
      t.boolean :status
      t.string :category
      t.string :image_url

      t.timestamps
    end
  end
end
