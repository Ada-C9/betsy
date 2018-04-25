class Order < ApplicationRecord
  has_many :order_items
  validates :status, presence: true
  validates :name, presence: true, length: { minimum: 3 }, unless: :in_cart?
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, unless: :in_cart?
  validates :street_address, presence: true, unless: :in_cart?
  validates :city, presence: true, unless: :in_cart?
  validates :state, presence: true, unless: :in_cart?
  validates :zip, presence: true, length: { is: 5 }, unless: :in_cart?
  validates :name_cc, presence: true, unless: :in_cart?
  validates :credit_card, presence: true, length: { in: 14..19 }, unless: :in_cart?
  # TODO: cannot submit order with current validation
  # validates :expiry, presence: true, unless: :in_cart?
  validates :ccv, presence: true, length: { in: 3..4 }, unless: :in_cart?
  validates :billing_zip, presence: true, length: { is: 5 }, unless: :in_cart?
  validate :cc_expiry_cannot_be_in_the_past, unless: :in_cart?

  def cc_expiry_cannot_be_in_the_past
    if expiry.present? && expiry.year < Date.today.year
      errors.add(:expiry, "can't be in the past")
    end
  end

  # validate :check_atleast_one_order_item, unless: :in_cart?

  # def check_atleast_one_order_item
  #   if order_items.count < 1
  #     errors.add(:order, "need atleast one order item")
  #   end
  # end

  def total_cost
    order_items.map { |order_item| order_item.subtotal }.sum.round(2)
  end

  def credit_card_last_digits
    credit_card[-4..-1]
  end

  def can_cancel?
    status == "paid" && !order_items.any? { |i| i.is_shipped }
  end

  private

  def in_cart?
    status == "pending"
  end
end
