class Cartitem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than: 0}

  def subtotal
    unit_price = self.product.price
    subtotal = unit_price * self.quantity
    return subtotal
  end

end
