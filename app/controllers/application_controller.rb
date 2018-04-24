class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_404_page
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  #does this render method stop the execution of a method and render a new view page? Do i need to make a view page named 404?


  # def render_404_message
  #       raise ActionController::RoutingError.new('Not Found')
  # end

  def not_found_check(object)
      if object.nil?
        render_404_page
      end
  end

  def find_user
    @user = User.find_by(id: session[:user_id])
  end

end
