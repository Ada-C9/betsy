class ChangeKeyOnOrderToBuyerdetail < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :buyerdetails_id
  end
end
