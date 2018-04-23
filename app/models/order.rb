class Order < ApplicationRecord
  belongs_to :cart

  validates :name, presence: true
  validates :email, presence: true
  validates :creditcard, presence: true, length: {is: 16}
  validates :expiration_month, presence: true
  validates :expiration_year, presence: true
  validates :name_on_card, presence: true
  validates :cvv, presence: true, length: {minimum: 3, maximum: 4}
  validates :mail_address, presence: true
  validates :billing_address, presence: true
  validates :status, presence: true
  validates :zipcode, presence: true

  def order_tax
    tax_value = 0.09
    cart = Cart.find(id: self.cart_id)
    tax = cart.subtotal * tax_value
   return tax
  end
#Sorry it is all double but need to dry it
  def total
    tax_value = 0.09
    cart = Cart.find(id: self.cart_id)
    total = (cart.subtotal * tax_value) + cart.subtotal
   return total

  end

end
