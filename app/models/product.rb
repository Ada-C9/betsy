class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :cartitems, dependent: :restrict_with_error
  has_many :reviews, dependent: :destroy
  # Included dependent destroy till we decide if we want these permanantly deleted -ALS
  belongs_to :merchant

  validates :name, presence: true
  validates :price, presence: true, numericality: {only_integer: true, greater_than: 0}

  def available?(new_quantity)
    return if self.stock > new_quantity
  end

  def average_rating
    return nil unless self.reviews.any?

    total = 0
    self.reviews.each do |review|
      total += review.rating
    end
    average_rating = total / self.reviews.count
    return average_rating
  end

  def self.to_categories
    category_hash = {}
    Category.all_categories.each do |category|
      category = category.singularize.downcase
      category_hash[category] = self.where(category: category)
    end
    return category_hash
  end
end
