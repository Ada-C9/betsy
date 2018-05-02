class Merchant < ApplicationRecord
  VALID_EMAIL = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  has_many :products

  validates :username, presence: true,
  length: { :minimum => 0 },
  uniqueness: true
  validates :email, presence: true,
  format: { with:  VALID_EMAIL },
  uniqueness: { case_sensitive: false }

  def self.build_from_github(auth_hash)
    Merchant.new(
      provider: auth_hash[:provider],
      uid: auth_hash[:uid],
      email: auth_hash[:info][:email],
      username: auth_hash[:info][:nickname])
  end

end
