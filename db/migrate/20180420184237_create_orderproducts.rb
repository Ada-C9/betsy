class CreateOrderproducts < ActiveRecord::Migration[5.1]
  def change
    create_table :orderproducts do |t|
      t.integer :quantity

      t.timestamps
    end
  end
end
