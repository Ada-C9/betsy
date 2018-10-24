class User < ApplicationRecord
  has_many :products
  has_many :reviews, through: :products
  has_attached_file :image, styles: { large: "300x300>", medium: "200x200#", thumb: "150x150#" }


  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def deactivate
    user = User.find_by(name: "Previous User")
    if !user
      user = User.create!(name: "Previous User", email: "previoususer@petsy.com")
    end
    self.products.each do |p|
      p.product_status = "retired"
      p.user_id = user.id
      return false unless p.save
    end
    return true
  end

  def avail_prod
    self.products.select{|p| !p.product_status && p.stock > 0}
  end

  def soldout_prod
    self.products.select{|p| !p.product_status && p.stock == 0}
  end

  def retired_prod
    self.products.select{|p| p.product_status == 'retired'}
  end

end
