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
    return [] if self.my_cartitems.empty?
    Cart.joins(:cartitems).where(cartitems: {id: self.my_cartitems.ids}).uniq
  end

  def my_orders
    return [] if self.my_cartitems.empty?
    Order.joins(:cart).where(carts: {id: self.my_carts.ids})
  end

  def my_total_revenue
    return 0 if self.my_cartitems.empty?
    total_revenue = 0
    self.my_orders.each do |order|
      order.cart.cartitems.where(id: self.my_cartitems).each do |item|
        revenue = item.product.price * item.quantity
        total_revenue += revenue
      end
    end
    return total_revenue
  end

  def my_revenue_by_status(status)
    return 0 if self.my_cartitems.empty?
    total_revenue = 0
    self.my_orders.where(status: status).each do |order|
      order.cart.cartitems.where(id: self.my_cartitems).each do |item|
        revenue = item.product.price * item.quantity
        total_revenue += revenue
      end
    end
    return total_revenue
  end
end
