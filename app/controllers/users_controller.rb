class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def create
    user_id = params[:user][:id]
    if user_id
      redirect_to user_products_path(user_id)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create a new user ID."
      flash[:messages] = @user.errors.messages
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      render_404
    else
      @user_products = @user.products
      # Model method for getting the relevant orders is needed

      if params[:term]
        @term = params[:term]
        @orders = @user.list_orders_by_status(@term)
        # raise
        @revenue = @user.total_revenue_by_status(@term)
        @num_orders = @user.num_orders_by_status(@term)
      else
        @orders = @user.list_all_orders
        @revenue = @user.total_revenue
        @num_orders = @user.num_orders
      end
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :uid, :provider, :term )
  end

end
