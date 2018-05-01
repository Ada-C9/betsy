class Product < ApplicationRecord
  has_many :order_products
  has_many :reviews, dependent: :destroy
  has_many :orders, through: :order_products
  has_and_belongs_to_many :categories
  belongs_to :merchant

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :price, presence: true
  validates :price, numericality: { only_integer: true, greater_than: 0}

end
