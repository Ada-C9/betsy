require_relative '20180422220445_add_product_id_to_review'

class FixLastMigration < ActiveRecord::Migration[5.1]
  def change
    revert AddProductIdToReview
  end
end
