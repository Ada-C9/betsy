class Cartitem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true,
  numericality: { only_integer: true, greater_than: 0 }
  validates :product, presence: true, uniqueness: { scope: :order }

  def update_stock
    quantity = self.quantity
    stock = self.product.stock
    self.product.stock = stock - quantity
    self.product.save
  end

  def mark_shipped
    self.shipped = DateTime.now
    self.save

    self.order.cartitems.each do |item|
      return if !item.shipped
    end

    self.order.state = "complete"
    self.order.save
  end

end
