class Category < ApplicationRecord
  has_and_belongs_to_many :products, join_table: :products_categories

  validates :name, presence: true, uniqueness: true 
end
