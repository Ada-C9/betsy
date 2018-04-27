class CategoriesController < ApplicationController
  before_action :require_login, only: [:new, :edit, :update, :destroy]
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
        flash[:status] = :success
        flash[:result_text] =  "Successfully created #{@category.name}"
        redirect_to categories_path
      else
        flash.now[:status] = :error
        flash.now[:result_text] = "Validations failed"
        flash.now[:messages] = @category.errors.messages
        render :new, status: :bad_request
      end
  end

  def show; end

  def edit; end

  def update
      @category.assign_attributes(category_params)
      if @category.save
        flash[:status] = :success
        flash[:result_text] = "Successfully updated #{@category.name}"
        redirect_to category_path(@category)
      else
        render :edit, status: :bad_request
      end
  end

  def destroy
      @category.destroy
      flash[:status] = :success
      flash[:result_text] =  "Successfully destroyed #{@category.name}"
      redirect_to categories_path
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
