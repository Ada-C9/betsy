class RemoveColumnStringFromOrder < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :string
  end
end
