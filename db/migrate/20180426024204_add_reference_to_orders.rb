class AddReferenceToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :buyerdetail, foreign_key: true
  end
end
