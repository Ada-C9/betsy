class Order < ApplicationRecord
 has_many :order_items
 has_many :products, through: :order_items


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
