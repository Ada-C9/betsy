class EditRelationships < ActiveRecord::Migration[5.1]
  def change
    remove_reference(:products, :cart_item)
    remove_reference(:orders, :cart_item)
  end
end
