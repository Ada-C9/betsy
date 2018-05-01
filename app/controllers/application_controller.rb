class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_order, :previous_order

  before_action :current_user
  before_action :current_order
  before_action :require_login

  def current_user
    @current_user ||= Merchant.find(session[:merchant_id]) if session[:merchant_id]
  end

# flashes message if current_user can't find a logged-in merchant
  def require_login
    unless current_user
      flash[:error] = "You must be logged in to do that."
      redirect_back fallback_location: root_path
    end
  end

  def current_order
    if session[:order_id]
      @current_order = Order.find(session[:order_id])
    else
      @current_order = Order.create(status: 'pending')
      session[:order_id] = @current_order.id
    end
    return @current_order
  end

end
