class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :cartitems
  has_many :reviews
  belongs_to :merchant

  validates :name, presence: true
  validates :price, presence: true, numericality: {only_integer: true, greater_than: 0}

end
