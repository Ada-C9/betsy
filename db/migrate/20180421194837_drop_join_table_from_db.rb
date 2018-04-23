class DropJoinTableFromDb < ActiveRecord::Migration[5.1]
  def change
    drop_table :products_categories do |t|
      t.integer "quantity"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
