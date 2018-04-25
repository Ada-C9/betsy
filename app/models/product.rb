class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :cartitems, dependent: :restrict_with_error
  has_many :reviews, dependent: :destroy
  # Included dependent destroy till we decide if we want these permanantly deleted -ALS
  belongs_to :merchant

  validates :name, presence: true
  validates :price, presence: true, numericality: {only_integer: true, greater_than: 0}

  def available?(new_quantity)
    return self.stock >= new_quantity
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

  def new_stock(items_bought)
    new_total = self.stock - items_bought
    return new_total
  end

end
