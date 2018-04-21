class Category < ApplicationRecord
  has_and_belongs_to_many :products
  validates :name, presence: true, uniqueness: true
  before_validation :capitalize_name

  private
  def capitalize_name
    if !self.name.nil?
      self.name = self.name.capitalize
    end
  end
end
