class Order < ApplicationRecord
  belongs_to :cart

  validates :name, presence: true, unless: :is_pending
  validates :email, presence: true,  unless: :is_pending
  validates :creditcard, presence: true, length: {is: 16},  unless: :is_pending
  validates :expiration_month, presence: true,  unless: :is_pending
  validates :expiration_year, presence: true,  unless: :is_pending
  validates :name_on_card, presence: true,  unless: :is_pending
  validates :cvv, presence: true, length: {minimum: 3, maximum: 4},  unless: :is_pending
  validates :mail_address, presence: true,  unless: :is_pending
  validates :billing_address, presence: true,  unless: :is_pending
  validates :status, presence: true
  validates :zipcode, presence: true,  unless: :is_pending


  def is_pending
    return true if self.status == "pending"
  end


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
