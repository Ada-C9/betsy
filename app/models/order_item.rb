class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than: 0}
  validate :available?
  validate :available_quantity

  def available?
    product = self.product
    if product.stock == 0
      errors.add(:stock, "out of stock")
    end
  end

  def available_quantity
    quantity = self.quantity
    if quantity > self. product.stock
      errors.add(:stock, "is #{self.product.stock}")
    end
  end

  def sub_total
    price = self.product.price
    quantity = self.quantity
    sub_total = price * quantity

    return sub_total
  end



end
