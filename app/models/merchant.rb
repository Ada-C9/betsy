class Merchant < ApplicationRecord
  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new(
      username: auth_hash[:info][:nickname],
      email: auth_hash[:info][:email],
      uid: auth_hash[:uid],
      provider: auth_hash[:provider]
    )
    merchant.save
    return merchant
  end

  def show_four
    if self.visible_products.count > 4
      return self.visible_products.first(4)
    end
    return self.visible_products
  end

  def visible_products
    return self.products.reject{ |pro| pro.visible == false }
  end

  def invisible_products
    return self.products.reject{ |pro| pro.visible == true}
  end

  def my_cartitems
    Cartitem.joins(:product).where(products: { merchant_id: self.id })
  end

  def my_carts
    Cart.joins(:cartitems).where(cartitems: {id: self.my_cartitems.ids})
  end

  def my_orders
    Order.joins(:cart).where(carts: {id: self.my_carts.ids})
  end

  def get_total_revenue
    total_revenue = 0
    my_cartitems.each do |item|
      subtotal = item.product.price * item.quantity
      total_revenue += subtotal
    end
    return total_revenue
  end

# TODO: calculate order numbers based on status
  def get_order_numbers

  end
end
