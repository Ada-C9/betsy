class Review < ApplicationRecord
  validates :rating, presence: true
  validates_numericality_of :rating, only_integer: true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5
  validates :description, presence: true
  belongs_to :product
end
