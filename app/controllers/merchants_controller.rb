class MerchantsController < ApplicationController

  before_action :require_login

  def account_page #show - only visible by OAuth
  end

  def order_fulfillment
    @order_products = []
    @merchant_orders = []
    order_products = OrderProduct.all
    order_products = OrderProduct.status(params[:status]) if params[:status]
    order_products.each do | order_product |
      @order_products << order_product if order_product.merchant == @current_merchant
    end
    @current_merchant.products.each do |product|
      product.order_products.each { |order_product| @merchant_orders << order_product }
    end
  end

  def products_manager
    @products = @current_merchant.products
  end
end
