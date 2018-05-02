class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  # before_validation(on: :save) do
  #   Order.new
  # end
  validates :quantity, presence: true, numericality: { only_integer: true }
  validate :quantity_limits

  def quantity_limits
    if quantity.to_i > product.stock
      errors.add(:quantity, "Only #{product.stock} are available")
    end
  end

  def get_subtotal
    price * quantity
  end

  def get_subtotal_to_string
    return get_subtotal
  end

  def get_order_status
    return order.status
    # Order.find(order_id).status
  end

  def get_item_name
    return product.name
    # Product.find(product_id).name
  end

  def get_item_merchant
    return product.merchant.username
    # merchant_id = Product.find(product_id).merchant_id
    # Merchant.find(merchant_id).username
  end

  def get_item_merchant_id
    return product.merchant.id
    # merchant_id = Product.find(product_id).merchant_id
    # Merchant.find(merchant_id).id
  end

  def shipping_status
    # Review the logic on this when all logic is figured out. Also, our logic
    # currently has 'complete' mean that the order has shipped. But does this
    # makes sense if merchants can mark individual items as shipped? - Kirsten
    if is_shipped == false && get_order_status == "paid"
      shipping_status = "Ready to ship"
    elsif is_shipped == false
      shipping_status = "Not shipped"
    else is_shipped == false
      shipping_status = "Shipped"
    end
    # Possible refactor: - Kirsten
    # if is_shipped
    #   return "Shipped"
    # else
    #   return get_order_status == "paid" ? "Ready to ship" : "Not ready to ship"
    # end
  end

  # def table_view
  #   if table_order_items == @order.order_items
  #     table_view = "Order view"
  #   elsif table_order_items == @merchant.order_items
  #     table_view = "Merchant view"
  #   else
  #     table_view = "Item view"
  #   end
  # end

  private

end
