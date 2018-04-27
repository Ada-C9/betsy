class Order < ApplicationRecord
  has_many :orderitems
  has_many :products, through: :orderitems
  has_many :users, through: :products
  has_many :buyerdetails


  def find_existing(orderitem)
    result = orderitems.find_by(order_id: self.id, product_id: orderitem.product_id)

    if result
      new_quantity = result.quantity + orderitem.quantity
      orderitem = result
      orderitem.assign_attributes(quantity: new_quantity)
    end
    return orderitem
  end



  def subtotal(orderitem)
    price = orderitem.product.price

    orderitem.quantity * price
  end

  def total
    raw_total = 0
    self.orderitems.each do |orderitem|
      raw_total += subtotal(orderitem)

    end
    raw_total.round(2)
  end

  def tax
    (total * 0.104).round(2)
  end

  def order_total
    total + tax
  end

end
