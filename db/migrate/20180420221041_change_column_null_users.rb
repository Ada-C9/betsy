class ChangeColumnNullUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_null :users, :uid, :string, false
    change_column_null :users, :provider, :string, false
  end
end
