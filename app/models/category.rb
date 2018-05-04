class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true, uniqueness: true

  def show_products

    products = self.products

    each_product = products.each do |item|
      item
    end

    return each_product
  end

end
