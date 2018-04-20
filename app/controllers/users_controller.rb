class UsersController < ApplicationController

  def index
    @users = @user.all
  end

  def show
    @user = User.find_by(:id params[:id])
  end
end
