class Merchant < ApplicationRecord
  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new(
      username: auth_hash[:info][:name],
      email: auth_hash[:info][:email],
      uid: auth_hash[:uid],
      provider: auth_hash[:provider]
    )

    if merchant.save
      return merchant
    else
      raise ArgumentError.new
    end
  end

  def show_four
    if self.products.count > 4
      return self.products.first(4)
    end
    return self.products
  end
end
