class Review < ApplicationRecord
  belongs_to :product
<<<<<<< HEAD
  has_one :user, through: :products
=======
  belongs_to :user, optional: true
>>>>>>> master

  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5  }
  validates :reviewtext, length: { maximum: 500, too_long: "Review must be under 500 characters." }
end
