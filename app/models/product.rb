class Product < ApplicationRecord

  has_many :order_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  belongs_to :user, optional: true
  has_and_belongs_to_many :categories


  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {only_integer: true,  greater_than: 0}
  validates :stock, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}


  def show_rating
    @reviews = Review.all

    total = 0
    reviews = @reviews.where(product_id: self.id)

    return "No reviews" if reviews.count == 0

    reviews.each do |review|
      total += review.rating
    end

    average = total/reviews.count
    return average
  end

  def self.by_pet_type
    # {"cat"=>[product1]}
    products_by_pets = {}

    Product.all.each do |product|
      unless products_by_pets.key? product.pet_type
        # that pet type is not already there
        products_by_pets[product.pet_type] = []
      end
      products_by_pets[product.pet_type] << product
    end

    return products_by_pets
  end

  def self.pet_type(type)
    where(pet_type: type).limit(4)
  end

  def self.cat
    pet_type("cat")
  end

  def self.dog
    pet_type("dog")
  end

  def self.reptile
    pet_type("reptile")
  end

  def stock_reduction(quantity)
    stock = self.stock - quantity
    self.update(stock: stock)
  end



end
