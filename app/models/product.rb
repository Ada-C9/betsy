class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews
  # validates :user_id, presence: true

  validates :name, presence: true
  validates :price, presence: true, numericality: {
    greater_than: 0
  }

  validates :stock, presence: true, numericality: {
    greater_than_or_equal_to: 0,
    only_integer: true
  }

end
