class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show, :edit, :update, :destroy]
  before_action :find_user

  def index
    @merchants = Merchant.all
  end

  def show
  end

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new(merchant_params)
    if @merchant.save
      flash[:status] = "success"
      flash[:result_text] = "Merchant added!"
      redirect_to merchants_path
    else
      flash.now[:alert] = @merchant.errors
      render :new
    end
  end

  def edit
  end

  def update
    if @merchant.update(merchant_params)
      flash[:status] = "success"
      flash[:result_text] = "#{@merchant.username} updated!"
      redirect_to merchant_path(params[:id])
    else
      render :edit
    end
  end

  def destroy
    if @merchant != nil
      @merchant.destroy
      flash[:status] = "success"
      flash[:result_text] = "#{@merchant} removed!"
    else
      flash[:status] = "failure"
      flash[:result_text] = "#{@merchant} does not exit!"
    end
    redirect_to merchants_path
  end

  private

  def merchant_params
    return params.require(:merchant).permit(:username, :email)
  end

  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])
    render_404 unless @merchant
  end


end
