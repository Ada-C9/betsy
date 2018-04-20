class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user, through: :products

  validates :user_id, presence: true
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5  }
  validates :reviewtext, length: { maximum: 500, too_long: "Review must be under 500 characters." }
end
