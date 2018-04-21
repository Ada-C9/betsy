class Cartitem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than: 0}

  def subtotal
    unit_price = (self.product.price.to_f / 100)
    return (unit_price * self.quantity * 1.1).round(2)
  end

end
