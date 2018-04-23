class ChangeProductsIsActiveDefault < ActiveRecord::Migration[5.1]
  def change
    change_column_default :products, :is_active, from: nil, to: true
  end
end
