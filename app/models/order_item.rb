class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :check_product_is_active
  validate :check_quantity

  def check_product_is_active
    if !self.product.is_active
      errors.add(:is_active,"product is no longer available")
    end
  end

  def check_quantity
    if self.quantity > self.product.stock
      errors.add(:stock, "only #{self.product.stock} items available")
    end
  end
end
