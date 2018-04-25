class UsersController < ApplicationController

  def index
    @users = User.where.not(username: "guest")
  end

  def show
    id = params[:id]
    @user = User.find(id)
  end

  def update
    user = User.find_by(id: params[:id])
    user.update(user_params)
    flash[:success] = "#{user.username} updated"
    redirect_to user_path(params[:id])
  end

  private
  def user_params
    return params.require(:user).permit(:username, :id, :email)
  end
end
