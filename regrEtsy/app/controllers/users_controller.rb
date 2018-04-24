class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
    # if @products.user_id == @user.id
    #   @products = Products.find_by(user_id: params[:user_id])
    # end
  end

private

  def user_params
    params.require(:user).permit(:name, :username, :password, :email)
  end

  def render_404
    render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end
end
