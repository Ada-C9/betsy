class Review < ApplicationRecord
  belongs_to :product

  validates :rating, presence: true
  validates :rating, :inclusion => 1..5
  # validates :comment, length: { in: 1..250 }
end
