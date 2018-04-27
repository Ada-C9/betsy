class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  def self.merchant_products(id)
    Product.where(user_id: id)
  end

  def self.merchant_orders(id)
    merchandise = merchant_products(id)

    orders = []
    merchandise.each do |item|
      item.orders.each do |ord|
        orders << ord
      end
    end

    return orders.uniq
  end

 def get_total
   total = 0
   self.order_items.each do |item|
     product = Product.find(item.product_id)
     sub_total = product.price * item.quantity
     total += sub_total
   end

   return total
 end


end
