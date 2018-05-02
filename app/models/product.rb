class Product < ApplicationRecord
  has_many :orders,through: :orderproduct
  has_and_belongs_to_many :categories, join_table: "category_product"
  has_many :reviews

  validates :name, uniqueness: true, presence: true, length: { minimum: 1 }
  validate :has_atleast_one_category
  validates_numericality_of :quantity, presence: true, greater_than_or_equal_to: 0
  validates_numericality_of :price, presence: true, greater_than_or_equal_to: 0
  validates :status, presence: true


  def average_rating
    return "No reviews yet" if reviews.count == 0
    sum = 0.0
    self.reviews.each do |review|
      sum += review.rating
    end
    return (sum/reviews.count)
  end

  def change_status
    self.status == "active" ? self.status = "retired" : self.status = "active"
    self.save
  end

  private

  def has_atleast_one_category
    if categories.empty?
      errors.add(:categories, "must have atleast one category")
    end
  end

end
