class SessionsController < ApplicationController

  def login
    auth_hash = request.env["omniauth.auth"]
    if auth_hash["uid"]
      @merchant = Merchant.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"])

      if @merchant.nil?
        @merchant = Merchant.build_from_github(auth_hash)
        if @merchant.id
          flash[:status] = :success
          flash[:result_text] = "#{@merchant.username} successfully logged in as a new merchant"
        else
          flash[:status] = :failure
          flash[:result_text] = @merchant.errors.messages
        end
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
    find_merchant
    if session[:merchant_id] == @login_merchant.id
      session[:merchant_id] = nil
      flash[:status] = :success
      flash[:result_text] = "Successfully logged out"
    elsif session[:merchant_id] != @login_merchant.id
      flash[:status] = :failure
      flash[:result_text] = "You can only log your account out"
    else
      flash[:status] = :failure
      flash[:result_text] = "You must login in"
    end
    redirect_to root_path
  end
end
