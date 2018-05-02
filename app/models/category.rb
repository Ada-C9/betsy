class Category < ApplicationRecord
  has_and_belongs_to_many :products

  before_validation :remove_white_space_from_name

  validates :name,  presence: true,
  length: { minimum: 1 },
  uniqueness: { case_sensitive: false }
  validate :products_or_error


  private

  def products_or_error
    self.products.each { |product| product_or_error(product) }
  end

  def product_or_error(new_product)
    raise ArgumentError.new("Invalid product") if !new_product.is_a?(Product)
  end

  def remove_white_space_from_name
    self.name.squish! if !self.name.nil?
  end
end
