class AddDeliveryMethods < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :delivery_method, :string
  end
end
