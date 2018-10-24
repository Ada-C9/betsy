class Product < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :categories, join_table: :products_categories, :default_url => ":style/not_found.jpg"
  has_many :reviews
  has_attached_file :image, styles: { large: "350x350>", medium: "200x200#", thumb: "150x150#" }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates :name, presence: true, uniqueness: { scope: :user }
  validates :price, presence: true, numericality: { greater_than: 0}
  validates :stock, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}



end
