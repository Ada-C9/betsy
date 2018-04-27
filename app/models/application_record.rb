class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_user
    @user = User.find_by(id: session[:user_id])
  end

end
