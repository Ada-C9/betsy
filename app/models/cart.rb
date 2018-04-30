class Cart < ApplicationRecord
  has_many :cartitems
  has_many :products, through: :cartitems
  has_one :order

  TAXRATE = 0.10

  def subtotal
    subtotal = 0
    self.cartitems.each do |cartitem|
      subtotal += cartitem.subtotal
    end
    # self.cartitems.inject {|total, cartitem.subtotal| total + subtotal}
    return subtotal
  end

  def total_items
    total_items = 0
    self.cartitems.each do |item|
      total_items += item.quantity
    end
    return total_items
  end

  def tax
    tax = self.subtotal * TAXRATE
    return tax
  end

  def total_cost
    total_cost = self.subtotal + self.tax
    return total_cost
  end
end
