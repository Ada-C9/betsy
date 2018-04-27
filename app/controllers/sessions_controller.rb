class SessionsController < ApplicationController
    skip_before_action :require_login

  def new
    @user = User.new
  end

  def create
    auth_hash = request.env['omniauth.auth']

    if auth_hash[:uid]
      user = User.find_by(uid: auth_hash[:uid], provider: 'github')
      if user.nil?
        # User doesn't match anything in the DB
        # Attempt to create a new user
        user = User.build_from_github(auth_hash)
      end

      # If we get here, we have the user instance
      session[:user_id] = user.id
      flash[:status] = :success
      flash[:result_text] = "Logged in successfully"
      redirect_to root_path
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not log in"
      flash[:messages] = user.errors.messages
      redirect_to root_path
    end
  end


  def logout
    if session[:user_id]
      session.delete(:user_id)
      flash[:result_text] = "Successfully logged out"
      redirect_to root_path
    end
  end
end
