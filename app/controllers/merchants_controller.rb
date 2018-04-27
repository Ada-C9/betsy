class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all.paginate(:page => params[:page], :per_page => 3)
  end

  def show
    @merchant = Merchant.find_by(id: session[:merchant_id])
    if session[:merchant_id].to_s == params[:id]
      @orders = @merchant.my_orders
    else
      flash[:status] = :failure
      flash[:result_text] = "You can not view other merchant's account page"
      redirect_back fallback_location: root_path
    end
  end

  def display
    @merchant = Merchant.find_by(id: params[:merchant_id])
  end

  def show_products
    @products = Product.where(merchant_id: params[:id])
    @merchant = Merchant.find_by(id: params[:id])
  end
  
  def by_name
    merchant_name = params[:username]
    @merchants = Merchant.where("LOWER(username) like ?", "%#{merchant_name.downcase}%")

    render :index
  end

end
