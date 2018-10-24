class Review < ApplicationRecord
  belongs_to :product
  has_one :user, through: :review

  validates :rating,
  presence: true,
  numericality: { only_integer: true, less_than: 6, greater_than: 0 }
end
