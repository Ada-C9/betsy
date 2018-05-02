class RemoveReferenceOrderFromProduct < ActiveRecord::Migration[5.1]
  def change
    remove_reference :orders, :product,foreign_key: true
  end
end
