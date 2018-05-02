class AddOrderIdToOrderproducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :orderproducts, :order, foreign_key: true
  end
end
