class User < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products
  has_many :orders, through: :order_items

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, uniqueness: true

  def self.build_from_github(auth_hash)
    return User.new(
      username: auth_hash[:info][:nickname],
      email: auth_hash[:info][:email],
      uid: auth_hash[:uid],
      provider: auth_hash[:provider]
    )
  end

  def num_orders
    order_items.map { |order_item| order_item.order }.uniq.count
  end

  def total_revenue
    order_items.map { |order_item| order_item.subtotal }.sum.round(2)
  end

  def num_orders_by_status(status)
    order_items.map { |order_item|
      order_item.order if order_item.order.status == status }.compact.uniq.count
  end

  def total_revenue_by_status(status)
    order_items.map { |order_item|
      order_item.subtotal if order_item.order.status == status }.compact.sum.round(2)
  end
end
