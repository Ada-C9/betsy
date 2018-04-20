class User < ApplicationRecord
  has_many :products
  has_many :orders_products, through: :products
  has_many :reviews, through: :products
  has_many :categories_products, through: :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
