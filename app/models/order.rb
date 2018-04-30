class Order < ApplicationRecord
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products
  has_many :merchants, through: :products
  before_save :update_status
  before_save :order_total

  validates :name, presence: true, if: :ready_to_process?

  validates :email, presence: true, if: :ready_to_process?, format: { with: /@/, message: "must include @" }

  validates :address, presence: true, if: :ready_to_process?, format: { with: /\A[\d]+/, message: "must start with digits" }

  validates :cc_num, presence: true, if: :ready_to_process?, format: { with: /\A[\d]{16}\z/, message: "16 digits only" }

  validates :cc_cvv, presence: true, if: :ready_to_process?, format: { with: /\A[\d]{3}\z/, message: "3 digits only" }

  validates :zip, presence: true, if: :ready_to_process?, format: { with: /\A[\d]+\z/, message: "digits only" }

  def ready_to_process?
    self.status == "in progress"
  end

  def order_total
    total = 0
    self.order_products.each do |order_product|
      total += order_product.subtotal
    end
    return total
  end

  def find_revenue_paid_orders(merchant)
  end

  # reduce the total num of products available when user pays for an order
  def decrement(order)
    order.order_products.each do |order_product|
      order_product.product.available -= order_product.quantity
    end
  end

  def update_status
    if self.status == nil
      self.status = "pending"
    end
  end

  def ship_order
    if self.status == "paid"
      self.status = "shipped"
      self.save
    end
  end

  def get_expiry(params)
    date = Date.new(params[:order]["expiry_date(1i)"].to_i,
                       params[:order]["expiry_date(2i)"].to_i,
                       params[:order]["expiry_date(3i)"].to_i)
    self.expiry_date = "#{date.month}/#{date.year}"
  end


  def find_order_merchants
    merchants = []
    self.order_products.each do |product|
      merchant = Merchant.find_by(product.merchant_id)
      merchants << merchant
    end
    return merchants
  end

end
