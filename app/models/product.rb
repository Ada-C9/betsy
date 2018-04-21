class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :cartitems, dependent: :nullify
  has_many :reviews, dependent: :nullify
  # Included dependent nullification till we decide if we want these permanantly deleted -ALS
  belongs_to :merchant

  validates :name, presence: true
  validates :price, presence: true, numericality: {only_float: true, greater_than: 0}

end
