class UsersController < ApplicationController
  before_action :require_login, only: [:show]
  # def new
  #   @user = User.new
  # end
  def index
    @merchants = User.all
  end

  def show
    @orders = @login_user.orders
    @products = @login_user.products
    @orders.each do |order|
      @orderitem = Orderitem.where(order_id: order.id)
      @customer = Buyerdetail.find_by(id: order.buyerdetail_id)
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :username, :password, :email)
  end
end
