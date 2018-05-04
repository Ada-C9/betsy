class SessionsController < ApplicationController
  before_action :find_user, only: [:show, :index]
  skip_before_action :current_user

  def index
    # @user = User.find_by(id: params[:id])
    if current_user && session[:user_id]
      @products_sold =[]
      orders_paid= Order.where(status: "paid")
      orders_paid.each do |po|
        po.order_items.each do |op|
          product = Product.find_by(id: op.product_id)
          if product.user_id == @user.id
            @products_sold << product
          end
        end
      end
      @total_revenue = 0
      @products_sold.each do |product|
        @total_revenue  += product.price
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "You need to login in to see this page"
      redirect_to user_path
    end
  end

  def new
    @user = User.new
  end

  def create
    auth_hash = request.env['omniauth.auth']

    if auth_hash['uid']
      @user = User.find_by(uid: auth_hash['uid'], provider: 'github')

      if @user.nil?
        @user = User.info_from_github(auth_hash)
        if @user.save
          session[:user_id] = @user.id
          flash[:success] = "Successfully created new user #{@user.username} with ID #{@user.id}"

        else
          flash[:error] = "Could not log in"
          flash[:messages] = @user.errors.messages

        end
      else
        session[:user_id] = @user.id
        flash[:success] = "Successfully logged in #{@user.username} as existing user!"

      end
      session[:user_id] = @user.id

    else
      flash[:error] = "Could not authenticate user via Github"

    end
    redirect_to root_path
  end

  def logout
    if session[:user_id]
      session[:user_id] = nil
      flash[:result_text] = "Successfully logged out"
      redirect_to root_path
    end
  end


  # def destroy
  #   session[:user_id] = nil
  #   flash[:success] = "Successfully logged out!"
  #
  #   redirect_to root_path
  # end

  private
  def find_user
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

end
