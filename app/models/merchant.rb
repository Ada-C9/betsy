class Merchant < ApplicationRecord
  has_many :products

  validates :username, uniqueness: true, presence: true
  validates :email, presence: true, uniqueness: true
  validates :uid, uniqueness: true, presence: true


  def self.build_from_github(auth_hash)
    # valid_auth_hash_or_error(auth_hash)
    create_new_merchant(auth_hash)
  end

  def get_merchant_products
    return products
    # Product.where(merchant_id: self.id)
  end

  def get_merchant_orders(status)
    if status == "all"
      order_ids = get_merchant_order_items.collect { |order_item| order_item.order_id }
      Order.where(:id => order_ids).where("orders.status = ? OR orders.status = ?", "paid","complete")
    elsif
      order_ids = get_merchant_order_items.collect { |order_item| order_item.order_id }
      Order.where(:id => order_ids).where("orders.status = ?", status)
    end
  end

  def get_merchant_revenue(status)
    order_items = OrderItem.where(order_id: self.get_merchant_orders(status), product_id: self.get_merchant_products)
    order_items.inject(0) { |sum, order_item| sum + (order_item.get_subtotal) }
  end

  def active_products
    return self.products.select { |product| !product.discontinued }
  end

  def inactive_products
    return self.products.select { |product| product.discontinued }
  end

  private

  def get_merchant_order_items
    # products.
    # return products.select { |product| productmerchant_products(merchant_id) }
    OrderItem.where(product_id: self.get_merchant_products)
  end

  # # Throw ArgumentError if provided auth_hash is not a hash or if it does not
  # # have the key :info.
  # def self.valid_auth_hash_or_error(auth_hash)
  #   if !auth_hash.is_a?(OmniAuth::AuthHash) || !auth_hash.has(:info)
  #   raise ArgumentError.new("Invalid initial format from provider")
  #   end
  # end

  # PRE: provided auth_hash must be a hash and have the key :info.
  # Returns a new instance of Merchant, using the provided auth_hash to supply
  # provider, uid, email, and username.
  def self.create_new_merchant(auth_hash)
    return Merchant.new(
      provider: auth_hash[:provider],
      uid: auth_hash[:uid],
      email: auth_hash[:info][:email],
      username: get_valid_name(auth_hash[:info])
    )
  end

  def self.get_valid_name(auth_hash_info)
    if auth_hash_info[:name].nil? || auth_hash_info[:name].empty?
      return auth_hash_info[:nickname]
    else
      return  auth_hash_info[:name]
    end

  end

end
