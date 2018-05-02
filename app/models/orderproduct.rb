class Orderproduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity ,presence: true

  def self.create_orderproduct(quantity, product_id, order_id)
    orderproduct = Orderproduct.new
    # change quantity to reflect user selection
    product = Product.find(product_id)
    #product.quantity = quantity
    product.save
    # assign form vars to new orderproduct
    orderproduct.quantity = quantity
    orderproduct.product_id = product_id
    orderproduct.order_id = order_id
    return orderproduct
  end

  def sub_total
    quantity * self.product.price
  end

end
