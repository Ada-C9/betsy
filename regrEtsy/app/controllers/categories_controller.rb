class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Successfully created #{@category.name}"
      redirect_to categories_path
    else
      flash[:error] = "Could not create #{@category.name}"
      flash[:messages] = @category.errors.error_messagesrender :new, status: :bad_request
    end
  end

  def show; end

  def edit; end

  def update
    @category.assign_attributes(category_params)
    if @category.save
      redirect_to category_path(@category)
    end
  end

  def destroy
    if session[:user_id] #maybe @login_user || @admin_user in future?
      @category.destroy
      flash[:success] = "Successfully destroyed #{@category.name}"
      redirect_to categories_path
    else
      flash[:error] = "You do not have permission to delete a category"
      #render_401
      redirect_to categories_path
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])

    head :not_found unless @category
  end

end
