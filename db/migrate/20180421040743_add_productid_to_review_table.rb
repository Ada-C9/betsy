class AddProductidToReviewTable < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :user_id, :bigint
  end
end
