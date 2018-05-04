class User < ApplicationRecord
  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.info_from_github(auth_hash)

    user_data = {
      uid: auth_hash[:uid],
      username: auth_hash[:info][:nickname],
      email: auth_hash[:info][:email],
      provider: auth_hash[:provider]}

      @user = self.new(user_data)
      @user.save
        return @user

  end


end
