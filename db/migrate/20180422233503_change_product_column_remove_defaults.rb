class ChangeProductColumnRemoveDefaults < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:products, :stock, nil)
    change_column_default(:products, :photo, nil)
  end
end
