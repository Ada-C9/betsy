class Cart < ApplicationRecord
  has_many :cartitems
  has_many :products, through: :cartitems
  has_one :order

  def subtotal
    sub_total = 0
    self.cartitems.each do |cartitem|
      sub_total += cartitem.subtotal
    end
    # self.cartitems.inject {|total, cartitem.subtotal| total + subtotal}
    return sub_total
  end
end
