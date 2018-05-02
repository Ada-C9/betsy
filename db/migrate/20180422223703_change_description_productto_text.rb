class ChangeDescriptionProducttoText < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :description, :text
    change_column :products, :stock, :integer, :null => false, :default => 0
    change_column :products, :photo, :string, :null => false, :default => "https://spaceholder.cc/350x350"
  end
end
