class User < ApplicationRecord

  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
    return User.new(
      provider: auth_hash[:provider], uid: auth_hash[:uid], email: auth_hash[:info][:email], username: auth_hash[:info][:nickname]
    )
  end

end
