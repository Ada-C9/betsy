class Cart < ApplicationRecord
  has_many :cartitems
  has_many :products, through: :cartitems

  def total_cost

  end
end
