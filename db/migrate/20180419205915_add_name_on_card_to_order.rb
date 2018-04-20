class AddNameOnCardToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :name_on_card, :string
  end
end
