class UsersController < ApplicationController

  def index
    @users = User.where.not(username: "guest")
  end

  def show
    id = params[:id]
    @user = User.find(id)
  end

end
