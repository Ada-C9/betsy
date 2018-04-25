class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true, uniqueness: true, length: { maximum: 30, too_long: "Name must be shorter than 30 characters."
  }

end
