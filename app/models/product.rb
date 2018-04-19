class Product < ApplicationRecord
  has_many :cartitems
  belongs_to :merchant
  has_many :reviews
  
end
