class User < ApplicationRecord
  before_validation :downcase_email

  has_many :products, dependent: :destroy
  has_many :orderitems, through: :products
  has_many :orders, through: :orderitems

  validates :username, presence: true, uniqueness: true
  # validates :password, presence: true
  # validates :email, uniqueness: { message: 'Email is already in use' }
  # def user_name(auth_hash)
  #   return if auth_hash.nil?
  #   email = auth_hash.split('@')
  #   return email[0]
  # end

  def self.build_from_github(auth_hash)

    user_data = {
      uid: auth_hash[:uid],
      username: auth_hash["info"]["nickname"],
      email: auth_hash["info"]["email"],
      provider: auth_hash[:provider]
    }

    user = self.new(user_data)
    if user.save
      return user
    end
  end

  private
  def downcase_email
    self.email = email.downcase if email.present?
  end
end
