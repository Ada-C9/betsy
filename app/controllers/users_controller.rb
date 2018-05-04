class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit]
  before_action :current_user

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:status] = "success"
      flash[:result_text] = "User added!"
      redirect_to users_path
    else
      flash.now[:alert] = @user.errors
      render :new
    end
  end

  def show

    @user = User.find_by(id: params[:id])
    head :not_found unless @user

    @products = @user.products

  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:status] = "success"
      flash[:result_text] = "#{@user.username} updated!"
      redirect_to user_path(params[:id])
    else
      render :edit
    end
  end

  def user_params
    return params.require(:user).permit(:username, :email)
  end

  def find_user
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end
end
