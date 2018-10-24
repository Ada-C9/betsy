class AddRelationshipProductCartItem < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :cart_item, add_foreign_key: true
  end
end
