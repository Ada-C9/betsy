class ChangeForeignKeyUserForProducts < ActiveRecord::Migration[5.1]
  def change
    rename_column :products, :users_id, :user_id
  end
end
