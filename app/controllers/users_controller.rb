class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def create
    user_id = params[:user][:id]
    if user_id
      redirect_to user_products_path(user_id)
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
    @user_products = @user.products
    # Model method for getting the relevant orders is needed
  end

end
