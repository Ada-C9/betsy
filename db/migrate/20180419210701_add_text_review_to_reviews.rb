class AddTextReviewToReviews < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :text_review, :string
  end
end
