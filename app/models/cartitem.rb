class Cartitem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :cart_id, uniqueness: { scope: :product_id, message: "This item is already in your cart, please update quantity in cart." }

  def subtotal
    unit_price = self.product.price
    subtotal = unit_price * self.quantity
    return subtotal
  end

end
