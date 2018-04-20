class UsersController < ApplicationController

  def index
    @user = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "User #{@user.username} successfully logged in"
      redirect_to root_path
    else
      flash[:error] = "Could not log in"
      redirect_to root_path
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render :edit
    end
  end


  def user_params
    params.require(:user).permit(:name, :username, :password, :email)
  end
end
