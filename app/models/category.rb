class Category < ApplicationRecord
  has_and_belongs_to_many :products
  validates :name, presence: true
  validates :name, uniqueness: true

  def self.products_by_category
    cat_prod = {}
    all.each do |c|
      cat_prod[c] = c.products
    end
    return cat_prod
  end

end
