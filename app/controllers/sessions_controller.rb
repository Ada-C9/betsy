class SessionsController < ApplicationController
  def new
      @username = User.new
  end

  def create
    auth_hash = request.env['omniauth.auth']
    if auth_hash[:uid]
      @user = User.find_by(uid: auth_hash[:uid], provider: 'github')
      if @user.nil?
        @user = User.build_from_github(auth_hash)
        successful_save = @user.save
        if successful_save
          flash[:success] = "Logged in successfully"
          redirect_to products_path
        else
          flash[:error] = "An error occurred during User creation"
          redirect_to products_path
        end
      else
        flash[:success] = "Logged in successfully"
        redirect_to products_path
      end
      session[:user_id] = @user.id
    else
      flash[:error] = "Logging in through Github not successful"
      redirect_to products_path
    end
  end

  def index
    @user = User.find(session[:user_id]) # < recalls the value set in a previous request
  end

  def destroy
    session[:user_id] = nil
    flash[:succes] = "Successfully logged out"

    redirect_to products_path
  end

end
