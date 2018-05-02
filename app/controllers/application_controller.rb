class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :find_merchant

  def find_merchant
    @merchant = Merchant.find_by(id: session[:merchant_id])
  end

  def render_404
    render file: "/public/404.html", status: :not_found, :layout => false
  end

  private

  # # Check that the user is logged in, and send back
  # # an error if they are not
  # # Store the looked-up user in @user in case
  # # someone wants to use it later.
  # # We write this method here so it will be available
  # # in _all_ controllers
  # def require_login
  #   @merchant = Merchant.find_by(id: session[:merchant_id])
  #   head :unauthorized unless @merchant
  # end

end
