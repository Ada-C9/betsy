class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items


  validates :name_on_card, presence: true,  on: :update
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :update }
  validates :cc_num, presence: true, format: { with: /\A\d+\z/ }, on: :update, length: 15..16
  validates :cvv, presence: true, numericality: {greater_than_or_equal_to: 0, only_integer: true}, length: { is: 3 }, on: :update
  validates :street_address, presence: true, on: :update
  validates :city, presence: true,format: { with: /\A[a-zA-Z]+(?: [a-zA-Z]+)?\z/ }, on: :update
  validates :zip, presence: true, format: { with: /\A\d+\z/ }, on: :update, length: { is: 5}



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

 STATES =
   [
     ['Alabama', 'AL'],
     ['Alaska', 'AK'],
     ['Arizona', 'AZ'],
     ['Arkansas', 'AR'],
     ['California', 'CA'],
     ['Colorado', 'CO'],
     ['Connecticut', 'CT'],
     ['Delaware', 'DE'],
     ['District of Columbia', 'DC'],
     ['Florida', 'FL'],
     ['Georgia', 'GA'],
     ['Hawaii', 'HI'],
     ['Idaho', 'ID'],
     ['Illinois', 'IL'],
     ['Indiana', 'IN'],
     ['Iowa', 'IA'],
     ['Kansas', 'KS'],
     ['Kentucky', 'KY'],
     ['Louisiana', 'LA'],
     ['Maine', 'ME'],
     ['Maryland', 'MD'],
     ['Massachusetts', 'MA'],
     ['Michigan', 'MI'],
     ['Minnesota', 'MN'],
     ['Mississippi', 'MS'],
     ['Missouri', 'MO'],
     ['Montana', 'MT'],
     ['Nebraska', 'NE'],
     ['Nevada', 'NV'],
     ['New Hampshire', 'NH'],
     ['New Jersey', 'NJ'],
     ['New Mexico', 'NM'],
     ['New York', 'NY'],
     ['North Carolina', 'NC'],
     ['North Dakota', 'ND'],
     ['Ohio', 'OH'],
     ['Oklahoma', 'OK'],
     ['Oregon', 'OR'],
     ['Pennsylvania', 'PA'],
     ['Puerto Rico', 'PR'],
     ['Rhode Island', 'RI'],
     ['South Carolina', 'SC'],
     ['South Dakota', 'SD'],
     ['Tennessee', 'TN'],
     ['Texas', 'TX'],
     ['Utah', 'UT'],
     ['Vermont', 'VT'],
     ['Virginia', 'VA'],
     ['Washington', 'WA'],
     ['West Virginia', 'WV'],
     ['Wisconsin', 'WI'],
     ['Wyoming', 'WY']
   ]


end
