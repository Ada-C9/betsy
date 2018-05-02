class Order < ApplicationRecord
  has_many :order_items

  STATES = %w(
    AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO
    MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY
  )

  STATUS = %w(pending paid complete cancelled)

  validates :status, presence: true, inclusion: { in: STATUS }

  validates :state, presence: true,
                inclusion: { in: STATES },
                if: -> { !(is_pending? && state.nil?) }

  validate :validate_email_address,
              if: -> { !(is_pending? && email_address.nil?) }

  validate :validate_credit_card_expiration,
              if: -> { !(is_pending? && cc_exp_month.nil? && cc_exp_year.nil?) }

  validate :validate_cc_number,
              if: -> { !(is_pending? && cc_number.nil?) }

  validate :validate_cc_cvv,
              if: -> { !(is_pending? && cc_cvv.nil?) }

  validates_each :customer_name, :street, :city, :cc_name do |record, attrib, value|
    if !(record.is_pending? && value.nil?) && !is_non_empty_string?(value)
      record.errors[attrib] << "Invalid #{attrib} - cannot be empty"
    end
  end

  validates_each :mailing_zip, :cc_zip do |record, attribute, value|
    if !(record.is_pending? && value.nil?) && !is_zip_code?(value)
      record.errors[attribute] << "Invalid #{attribute} - must be 5 digits"
    end
  end

  def total_quantity
    return order_items.inject(0) { |sum, order_item| sum + order_item.quantity }
  end

  def get_total_revenue
    return calc_revenue
  end

  def add_item_to_cart(new_order_item)
    order_items << new_order_item if is_pending?
  end

  def is_pending?
    return status == "pending"
  end

  # def is_not_allowed_to_change? # not used? - Kirsten
  #   return status != "pending"
  # end

  def delete_all_items_in_cart
    destroy_all_order_items if is_pending?
  end

  private

  def destroy_all_order_items
    order_items.each { |items| items.destroy }
  end

  def calc_revenue
    return order_items.inject(0) { |sum, item| sum + item.get_subtotal }
  end

  def validate_email_address
    if !email_address.is_a?(String) || !email_address.include?("@")
      errors.add(:email_address, "Invalid email address")
    end
  end

  def validate_credit_card_expiration
    if !Date.is_in_the_future?(cc_exp_month, cc_exp_year)
      errors.add(:credit_card_expiration, "Invalid credit card expiration date")
    end
  end

  def validate_cc_cvv
    if !cc_cvv.is_a?(String) || !cc_cvv.has_only_n_digits?(3)
      errors.add(:credit_card_cvv, "Invalid credit card cvv")
    end
  end

  def validate_cc_number
    if !cc_number.is_a?(Integer) ||
      !cc_number.between?(1_000_000_000_000_000, 9_999_999_999_999_999)
        errors.add(:credit_card_number, "Invalid credit card number")
    end
  end

  def self.is_zip_code?(zip)
    return zip.is_a?(String) && zip.has_only_n_digits?(5)
  end

end
