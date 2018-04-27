class RemoveAddColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :uid
    remove_column :users, :provider

    add_column :users, :uid, :string, null: false
    add_column :users, :provider, :string, null: false
  end
end
