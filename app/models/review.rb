class Review < ApplicationRecord
  belongs_to :product
  validates :rating, presence: true, numericality: { only_integer: true }
  validates_inclusion_of :rating, in: (1..5)



end
