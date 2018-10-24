class AddRelationshipOrderCart < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :cart_item, add_foreign_key: true
    add_reference :cart_items, :order, add_foreign_key: true

  end
end
