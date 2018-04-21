class Cart < ApplicationRecord
  has_many :cartitems
  has_many :products, through: :cartitems
  has_one :order
end
