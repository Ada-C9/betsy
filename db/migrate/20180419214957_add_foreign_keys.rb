class AddForeignKeys < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :merchant, foreign_key: true
    add_reference :cartitems, :product, foreign_key: true
    add_reference :cartitems, :cart, foreign_key: true
    add_reference :reviews, :product, foreign_key: true
    add_reference :orders, :cart, foreign_key: true
    

  end
end
