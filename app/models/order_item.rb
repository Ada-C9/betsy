class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order


  def get_subtotal
    product = Product.find(self.product_id)
    sub_total = product.price * self.quantity
    return sub_total
  end
end
