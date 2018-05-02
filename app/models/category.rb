class Category < ApplicationRecord
  has_and_belongs_to_many :products, join_table: "category_product"

  validates :name, presence: true, uniqueness: true, length: { in: 1..25 }
end
