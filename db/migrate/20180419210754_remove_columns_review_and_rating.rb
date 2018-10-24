class RemoveColumnsReviewAndRating < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :review
    remove_column :products, :rating
  end
end
