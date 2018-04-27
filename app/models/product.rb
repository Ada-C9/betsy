class Product < ApplicationRecord

  has_and_belongs_to_many :categories
  has_many :orderitems
  has_many :reviews
  belongs_to :user

  validates :name, presence: true, uniqueness: true, format: { with: /[a-zA-Z_\s]*/ }

  # This price validation allows values with an optional decimal place (if the decimal is present, no more than 2 digits must follow) and it can be up to 20 digits long
  validates :price, presence: true, numericality: { only_float: true, greater_than: 0 }


  def sufficient_stock(quantity)
    self.stock >= quantity
  end

  def decrement_stock(quantity)
    self.stock -= quantity
    self.save
  end

  def average_rating
    average = 0
    count = 0
    reviews.each do |r|
      if r.rating > 0
        count += 1
        average += r.rating
      end
    end

    return 0 if count == 0
    return average/count
  end

  def retire
      self.toggle! :retired
  end
end
