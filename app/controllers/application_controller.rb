class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_order
  before_action :find_product
  before_action :current_user
  before_action :require_login

  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end

  def user_name(auth_hash)
    return if auth_hash.nil?
    email = auth_hash.split('@')
    return email[0]
  end

  def set_order
    @order = Order.find_by(id: session[:order_id])
    if !@order || @order.status == "paid"
      @order = Order.create(status: :pending)
      session[:order_id] = @order.id
    end
  end

  def find_product
    if params[:product_id]
      @product = Product.find_by(id: params[:product_id])
      head :not_found unless @product
    end
  end

  def current_user
    @user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    unless current_user
      flash[:status] = :failure
      flash[:result_text] = "You must log in to see this content"
      redirect_back fallback_location: root_path
    end
  end


end
