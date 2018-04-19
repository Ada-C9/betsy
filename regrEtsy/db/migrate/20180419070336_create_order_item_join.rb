class CreateOrderItemJoin < ActiveRecord::Migration[5.1]
  def change
    create_table :order_item do |t|
      t.belongs_to :product, index: true
      t.belongs_to :order, index: true

      t.integer :quantity
    end
  end
end
