class Merchant < ApplicationRecord
  has_many :products
  has_many :orders
  # has_many :reviews
  has_many :product_categories, through: :products, source: :categories

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
    @merchant = Merchant.new(username: auth_hash['info']['nickname'], email: auth_hash['info']['email'], uid: auth_hash['uid'], provider: auth_hash['provider'])

  end

end
