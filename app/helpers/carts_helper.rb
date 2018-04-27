module CartsHelper

  #this needs a duck class
  def product_details(item)
    Product.find(item.product_id)
  end

  def quantity_edit?(fullpath)
  return true if fullpath == "/carts/#{@order.id}"
  end

end
