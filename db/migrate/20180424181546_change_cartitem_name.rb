class ChangeCartitemName < ActiveRecord::Migration[5.1]
  def change
    rename_table :cart_items, :cartitems
  end
end
