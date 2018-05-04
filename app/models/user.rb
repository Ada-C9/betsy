class User < ApplicationRecord

  has_many :products


  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
    return User.new(
      provider: auth_hash[:provider], uid: auth_hash[:uid], email: auth_hash[:info][:email], username: auth_hash[:info][:nickname]
    )
  end

  def get_order_items
    my_items = self.products

    mine = []
    my_items.each do |product|
      mine << product.order_items
    end
    return mine
  end

  def get_total_revenue
    mine = get_order_items

    total = 0

    mine.each do |o_items|
      o_items.each do |item|
      total += item.product.price * item.quantity
    end
    end
    return total
  end


end
