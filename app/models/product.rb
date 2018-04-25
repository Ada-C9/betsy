class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews

  # validates :user_id, presence: true

  validates :name, presence: true
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :stock, presence: true, numericality: {greater_than_or_equal_to: 0, only_integer: true}

  def average_rating
    return reviews.average(:rating).to_i
  end

  def self.by_category(category)
    assigned = Product.where.not(category: [])
    selected = assigned.select {|product| product.categories.include?(category)}

    return selected
  end

  def self.by_merchant(id)
    return Product.where(user_id: id)
  end


  def change_stock(quantity)
    total = self.stock
    number = total - quantity
    self.stock = number
    self.save

  end


end
