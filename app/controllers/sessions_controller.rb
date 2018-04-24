class SessionsController < ApplicationController
  # skip_before_action :require_login, only: [:create]

  # def failure
  #   auth_hash = request.env['omniauth.auth']
  #
  #   logger.debug "MADE IT TO FAILURE"
  #   logger.debug "Auth_hash = #{auth_hash}"
  #   logger.debug "params = #{params}"
  #
  # end

  def login
    auth_hash = request.env['omniauth.auth']

    # logger.debug "MADE IT TO LOGIN"
    # logger.debug "Auth_hash = #{auth_hash}"

    if auth_hash['uid']
      @merchant = Merchant.find_by(uid: auth_hash[:uid], provider: 'github')

      if @merchant.nil?
        #its a new user, we need to MAKE a new user
        @merchant = Merchant.build_from_github(auth_hash)
        successful_save = @merchant.save
        if successful_save
          flash[:success] = "Logged in Successfully. Welcome #{@merchant.username}"
          session[:merchant_id] = @merchant.id
          redirect_to root_path
        else
          flash[:alert] = "Some error happened in Merchant creation"
          redirect_to root_path
        end
      else
        flash[:success] = "Logged in successfully"
        session[:merchant_id] = @merchant.id
        redirect_to root_path
      end
    else
      flash[:alert] = "Logging in through Github not successful"
      redirect_to root_path
    end
  end

  def logout
    session[:merchant_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end
end
