class Cartitem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than: 0}
end
