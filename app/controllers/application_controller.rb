class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def find_merchant
    if session[:merchant_id]
      @login_merchant = Merchant.find_by(id: session[:merchant_id])
    end
  end

end
