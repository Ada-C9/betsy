class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
    @user_products = @user.products
    # Model method for getting the relevant orders is needed
  end

end
