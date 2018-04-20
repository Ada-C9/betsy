class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_login
    @user = User.find_by(id: session[:user_id])
    head :unauthorized unless @user 
  end

end
