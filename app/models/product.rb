class Product < ApplicationRecord
  has_many :cartitems
  belongs_to :merchant
  has_many :reviews

  validates :name, presence: true
  validates :price, presence: true, numericality: {only_float: true, greater_than: 0}

  def available?(new_quantity)
    return if self.stock > new_quantity
  end
end
