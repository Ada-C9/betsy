class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all.paginate(:page => params[:page], :per_page => 3)
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    head :not_found unless @merchant
  end

  def display
    @merchant = Merchant.find_by(id: params[:merchant_id])
  end
end
