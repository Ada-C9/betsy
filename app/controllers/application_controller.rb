class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def find_merchant
    if session[:merchant_id]
      @login_merchant = Merchant.find_by(id: session[:merchant_id])
    else
      flash[:status] = :failure
      flash[:message] = "You must log in to add a category"
      redirect_back fallback_location: root_path
    end
  end

end
