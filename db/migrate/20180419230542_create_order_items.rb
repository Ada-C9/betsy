class CreateOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :order_items do |t|
      t.integer :quantity
      t.boolean :is_shipped

      t.timestamps
    end
  end
end
