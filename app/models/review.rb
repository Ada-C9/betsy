class Review < ApplicationRecord
  belongs_to :product

  validates :rating, presence: true, numericality: { only_integer: true, less_than: 5, greater_than: 0 }
end
