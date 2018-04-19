class Order < ApplicationRecord
  has_one :cart

  validates :name , presence: true
  validates :email , presence: true
  validates :creditcard , presence: true, length: {is: 16}
  validates :expiration_date, presence: true
  validates :name_on_card , presence: true
  validates :cvv , presence: true, length: {minimum: 3, maximum: 4}
  validates :mail_address , presence: true
  validates :billing_address , presence: true
  validates :status , presence: true
  validates :zipcode, presence: true

end
