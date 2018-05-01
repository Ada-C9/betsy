module OrdersHelper

  def last_four(order)
    order.cc_num.last(4)
  end

  def date_placed(order)
    order.updated_at.strftime("%B %-d, %Y at %l:%M%P")
  end

end
