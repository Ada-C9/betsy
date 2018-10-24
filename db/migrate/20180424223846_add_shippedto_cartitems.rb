class AddShippedtoCartitems < ActiveRecord::Migration[5.1]
  def change
    add_column :cartitems, :shipped, :datetime
  end
end
