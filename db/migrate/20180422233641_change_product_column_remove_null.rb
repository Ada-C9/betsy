class ChangeProductColumnRemoveNull < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :stock, :integer, :null => true
    change_column :products, :photo, :string, :null => true
  end
end
