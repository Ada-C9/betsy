class DropOpJoin < ActiveRecord::Migration[5.1]
  def change
    drop_join_table :order, :product
  end
end
