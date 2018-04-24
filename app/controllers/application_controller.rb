class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_user

  def find_user
    @user = User.find_by(id: session[:user_id])
  end

  def render_404
    render file: "/public/404.html", status: 404
  end

end
