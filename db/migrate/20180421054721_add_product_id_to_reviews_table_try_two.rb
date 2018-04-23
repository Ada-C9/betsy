class AddProductIdToReviewsTableTryTwo < ActiveRecord::Migration[5.1]
  def change
    def change
      add_column :reviews, :product_id, :bigint
    end
  end
end
