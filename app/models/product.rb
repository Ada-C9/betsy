class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :reviews
  has_many :order_items
  belongs_to :merchant

  # before_validation :convert_price_to_int

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :merchant, presence: true
  validates :photo, presence: true
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 1 }

  # validates_length_of :category_ids, :minimum => 1
  def inventory_status
    return stock > 0 ? "In stock" : "Out of stock"
  end

 #  def get_average_rating
 #   return reviews.empty? ? "No ratings" : "#{calc_avg_rating.round(1)} out of 5"
 # end

  def get_average_rating
    sum = 0.0
    num = self.reviews.length
    self.reviews.each do |review|
      sum += review.rating
    end
    average = sum/num
    if average == 0 || average.nil? || average.nan?
      return "This product has no ratings"
    else
      return "#{format("%.1f", average)} out of 5"
    end
  end

  def self.products_available
    return self.select { |product| product.discontinued == false }
  end

  def get_price_in_dollars
    return price.cents_to_dollars
  end

  # Helper needed to convert float from creating new product form into an int.
  def price_from_form
    price # Please do not change! - Kirsten
  end

  # Needed to convert float from creating new product form into an int.
  def price_from_form=(form_price)
    self.price = (form_price.to_f * 100).to_i # Please do not change! - Kirsten
  end

  def self.merchant_products(merchant_id)
    # Do we actually need this or can this be done through relationships
    # however/wherever this is being used? - Kirsten
    return self.select { |product| product.merchant_id == merchant_id }
  end

  private

  # def calc_avg_rating
  #   reviews.inject(0.0) { |sum, review| sum + review.rating  } / reviews.size
  # end

  # Converts price into an int if price is a double.
  def convert_price_to_int
    # Please do not change! - Kirsten
    self.price = (self.price * 100).to_i if self.price.is_a?(Float)
  end
end
