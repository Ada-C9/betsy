class BuyerdetailAddReference < ActiveRecord::Migration[5.1]
  def change
    remove_column :buyerdetails, :order_id
    add_reference :buyerdetails, :order, foreign_key: true
  end
end
