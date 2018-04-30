class CreateCartitems < ActiveRecord::Migration[5.1]
  def change
    create_table :cartitems do |t|
      t.integer :quantity

      t.timestamps
    end
  end
end
