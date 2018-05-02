class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_404
    # raise ActionController::RoutingError.new('Not Found')
    render text: 'Not Found', status: '404'
  end

  private

  def find_user
    @user = Merchant.find_by(id: session[:merchant_id])
  end

  def find_order
    @order = Order.where(merchant_id: session[:merchant_id]).where(status: "open")
  end


  def current_order
    if !session[:order_id].nil?
      @order = Order.find(session[:order_id])
    else
      @order = Order.new
      @order.save
    end
  end

end
