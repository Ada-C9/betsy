class Order < ApplicationRecord
  has_many :cartitems

  validates_presence_of :name, :email, :ccnumber, :ccexpiration, :cvv, :address, :zipcode, on: :purchase
  validates_length_of :ccnumber, :within => 16..19, on: :purchase
  validates_length_of :cvv, :within => 3..4, on: :purchase
  validates :ccexpiration, inclusion: { in: (Date.today..Date.today + 5.years) }, on: :purchase

  def complete_checkout
    self.state = "paid"
    self.save
    self.cartitems.each do |item|
      item.update_stock
    end
  end


  def total
    items = Cartitem.where(order_id: self.id)
    totals = items.map{ |item| item.product.price * item.quantity }
    return totals.sum
  end

  def cancel
    self.cartitems.each do |item|
      item.product.stock += item.quantity
      if !item.product.save
        return false
      end
    end

    self.state = "cancelled"

    return self.save

  end


  def self.filter_by(user_id)
    items = []
    self.all.each do |order|
      order.cartitems.each do |item|
        if item.product.user.id == user_id
          items << item
        end
      end
    end
    return items
  end

end
