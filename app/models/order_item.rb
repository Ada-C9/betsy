class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :check_product_is_active, if: :contains_product?
  validate :check_quantity, if: :contains_product?

  def check_product_is_active
    if !self.product.is_active
      errors.add(:is_active,"product is no longer available")
    end
  end

  def check_quantity
    if self.quantity.to_i > self.product.stock
      errors.add(:stock, "only #{self.product.stock} items available")
    end
  end

  def subtotal
    ((quantity * product.price)/100.0).round(2)
  end

  private
  def contains_product?
    !self.product.nil?
  end

end
