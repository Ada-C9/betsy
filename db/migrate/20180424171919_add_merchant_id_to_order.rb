class AddMerchantIdToOrder < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :merchant, foreign_key: true
  end
end
