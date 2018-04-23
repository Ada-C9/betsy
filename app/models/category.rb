class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true, uniqueness: true

  def show_four
    if self.products.count > 4
      return self.products.first(4)
    end
    return self.products
  end
end
