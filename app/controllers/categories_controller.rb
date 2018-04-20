class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(id: params[:id])
  end

  def new
    if @user.nil?
      flash[:status]= :failure
      flash[:notice]= "You must be logged to add a new category!"
      redirect_to root_path, status: :bad_request
    else
      @category = Category.new
    end
  end

  def create
    if @user.nil?
      flash[:status] = :failure
      flash[:notice]= "You must be logged in to add a new category"
      redirect_to root_path
    else
      @category = Category.new(category_params)
      if @category.save
        flash[:status] = :success
        flash[:notice] = "Succesfully created category: #{@category.name}!"
        redirect_to categories_path
      else
        flash[:status] = :failure
        flash[:notice] = "Blah! Blah!"
        flash[:messages] = @category.errors.messages
        render :new, status: :bad_request
      end
    end
  end

  def edit
    @category = Category.find_by(id:params[:id])
    if @category.nil?
      redirect_to categories_path
    end
  end

  def update
  end

  def destroy
  end

  private
  def category_params
    return
    params.require(:category).permit(:name)
  end
end
