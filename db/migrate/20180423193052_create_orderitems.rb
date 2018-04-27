class CreateOrderitems < ActiveRecord::Migration[5.1]
  def change
    create_table :orderitems do |t|
      t.bigint "product_id", null: false
      t.bigint "order_id", null: false
      t.integer "quantity"
      t.timestamps
    end
  end
end
