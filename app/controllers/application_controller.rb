class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_404
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def not_found_check(object)
      if object.nil?
        render_404
      end
  end

  def find_user
    @user = User.find_by(id: session[:user_id])
  end

end
