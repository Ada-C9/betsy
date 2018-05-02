class AddProductIdToOrderproducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :orderproducts, :product, foreign_key: true
  end
end
