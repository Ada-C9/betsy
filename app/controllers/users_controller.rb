class UsersController < ApplicationController
<<<<<<< HEAD
=======

  def index
    @users = @user.all
  end

  def show
    @user = User.find_by(:id params[:id])
  end
>>>>>>> 61c556fe1cf047e087fa762e2892d4cae4821fc2
end
