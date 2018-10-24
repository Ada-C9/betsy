class SessionsController < ApplicationController
  
  def new ; end

  def create
    auth_hash = request.env['omniauth.auth']

    if find_user != nil
      flash[:failure] = "Could not log in, a user is already logged in"
      redirect_to root_path

    elsif auth_hash['uid']
      @user = User.find_by(uid: auth_hash[:uid], provider: 'github')

      if @user.nil?
        @user = User.new(
          name: auth_hash['info']['name'],
          email: auth_hash['info']['email'],
          uid: auth_hash['uid'],
          provider: auth_hash['provider'])


          if @user.save
            session[:user_id] = @user.id
            flash[:success] = "#{@user.name} created and logged in.  Welcome!"
            redirect_to root_path
          else
            flash[:failure] = "Could not log in, user could not be created"
            redirect_to root_path
          end

        else
          session[:user_id] = @user.id
          flash[:success] = "You are logged in, welcome back!"
          redirect_to root_path
        end

      else
        flash[:error] = "You could not login, we're sorry!"
        redirect_to root_path
      end
    end

    def destroy
      session.delete(:user_id)
      flash[:success] = "Logged out successfully.  Come back soon!"
      redirect_to root_path
    end

  end
