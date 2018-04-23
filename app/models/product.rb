class Product < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :reviews
  has_many :order_items
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :stock, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  def average_rating
    (reviews.average(:rating) || 0).round(1)
  end

  def toggle_is_active
    self.is_active = !is_active
  end

  def self.top_sellers(count = 5)
    sorted_products = self.all.sort_by { |p|
      p.order_items.map { |i| i.quantity }.sum
    }.reverse!
    actual_count = [count, sorted_products.count].min
    return sorted_products[0...actual_count]
  end

end
