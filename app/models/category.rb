class Category < ApplicationRecord
  has_and_belongs_to_many :products, join_table: :products_categories

  validates :name, presence: true, uniqueness: true

  def self.select_with_products
    Category.all.select do |cat|
      cat.products.count > 0
    end
  end

end
