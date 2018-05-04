class AddProductIdToReviewsTableTryThree < ActiveRecord::Migration[5.1]
  def change
    def change
      add_column :reviews, :user_id, :integer
    end
  end
end
