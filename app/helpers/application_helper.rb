module ApplicationHelper
  def price_in_dollar(price)
    sprintf('%.2f', (price / 100.00))
  end

  def pretty_date(date)
    return date.strftime("%b %e, %Y")
  end

  def discard_day(date)
    return date.strftime("%m/%Y")
  end

  # def display_image(photo_url)
  #   ["<img src='", "https://images.baxterboo.com/global/images/products/large/argyle-purple-dog-sweater-with-scarf-1197.jpg", "' alt='product image'>"].join.html_safe
  # end
end
