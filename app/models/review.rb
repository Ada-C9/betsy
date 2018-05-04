class Review < ApplicationRecord
  belongs_to :product
  # TODO Does the thing below need a migration?
  # counter_cache: :review_count


  validates :rating, presence: true

  validates :rating, numericality: {only_integer: true, less_than_or_equal_to: 5, greater_than: 0}

end
