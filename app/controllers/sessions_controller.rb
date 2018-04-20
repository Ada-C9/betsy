class SessionsController < ApplicationController

  def login
    auth_hash = request.env["omniauth.auth"]
    if auth_hash["uid"]
      @merchant = Merchant.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"])

      if @merchant.nil?
        @merchant = Merchant.build_from_github(auth_hash)
        flash[:status] = :success
        flash[:result_text] = "#{@merchant.username} successfully logged in as a new merchant"
      else
        flash[:status] = :success
        flash[:result_text] = "#{@merchant.username} successfully logged in as existing merchant"
      end
      session[:merchant_id] = @merchant.id

    else
      flash[:error] = "Could not log in"
    end

    redirect_to root_path
  end

  def logout
    session[:merchant_id] = nil
    flash[:status] = :success
    flash[:result_text] = "successfully logged out"
    redirect_to root_path
  end
end
