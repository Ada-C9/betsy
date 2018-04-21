class User < ApplicationRecord
  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.info_from_auth_hash(provider, auth_hash)
    user = new
    user.provider = provider
    user.uid = auth_hash['uid']
    user.username = auth_hash['info']['username']
    user.email = auth_hash['info']['email']

    return user

  end
end
