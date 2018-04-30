class SessionsController < ApplicationController

  skip_before_action :require_login

  def create
    auth_hash = request.env['omniauth.auth']

    if auth_hash['uid']
      @merchant = Merchant.find_by(uid: auth_hash['uid'], provider: 'github')

      if @merchant.nil?
        @merchant = Merchant.build_from_github(auth_hash)
        if @merchant.save
          session[:merchant_id] = @merchant.id
          flash[:success] = "Successfully created new user #{@merchant.username.capitalize} with ID #{@merchant.id}"
          redirect_to merchant_path(@merchant.id)
        else
          flash[:error] = "Could not log in"
          flash[:messages] = @merchant.errors.messages
          redirect_to root_path
        end
      else
        session[:merchant_id] = @merchant.id
        flash[:success] = "Welcome back #{@merchant.username.capitalize}!"
        redirect_to merchant_path(@merchant.id)
      end

    else
      flash[:error] = "Could not authenticate user via Github"
      redirect_to root_path
    end
  end


  def destroy
    session[:merchant_id] = nil
    flash[:success] = "You have been logged out"
    redirect_to root_path
  end
end
