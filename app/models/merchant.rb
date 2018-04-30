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
    my_cartitems = []
    Cartitem.all.each do |cartitem|
      if self.products.include?(cartitem.product)
        my_cartitems << cartitem
      end
    end
    return my_cartitems
  end

  def my_orders
    my_orders = []
    Order.all.each do |order|
      order.cart.cartitems.each do |cartitem|
        if self.products.include?(cartitem.product)
          my_orders << order
        end
      end
    end
    my_orders.uniq!
    return my_orders
  end

  def my_total_revenue
    return 0 if self.my_cartitems.empty?
    total_revenue = 0
    my_orders.each do |order|
      order.cart.cartitems.each do |item|
        if self.products.include?(item.product)
          revenue = item.product.price * item.quantity
          total_revenue += revenue
        end
      end
    end
    return total_revenue
  end

  def my_revenue_by_status(status)
    return 0 if self.my_cartitems.empty?
    total_revenue = 0
    orders_by_status = my_orders.select { |order| order.status.downcase == status }
    orders_by_status.each do |order|
      order.cart.cartitems.each do |item|
        if self.products.include?(item.product)
          revenue = item.product.price * item.quantity
          total_revenue += revenue
        end
      end
    end
    return total_revenue
  end
end
