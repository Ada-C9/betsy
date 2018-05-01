class OrderProduct < ApplicationRecord
  belongs_to :product
  belongs_to :order

  def subtotal
    subtotal = (self.product.price * self.quantity)
  end

  def find_order_product(merchant_id)
    product = Product.find(self.product_id)
  end

end
