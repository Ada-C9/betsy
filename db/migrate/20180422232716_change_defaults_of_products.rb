class ChangeDefaultsOfProducts < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :stock, :integer
    change_column :products, :photo, :string
  end
end
