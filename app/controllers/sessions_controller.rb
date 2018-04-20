class SessionsController < ApplicationController
  def new
      @username = User.new
  end

  def create

  end

  def destroy
    session[:user_id] = nil
    flash[:succes] = "Successfully logged out"
  end

end
