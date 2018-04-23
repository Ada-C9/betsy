module ApplicationHelper
  def price_in_dollar(price)
    sprintf('%.2f', (price / 100.00))
  end

  def pretty_date(date)
    return date.strftime("%b %e, %Y")
  end

  def display_image(photo_url)
    ["<img src='", photo_url, "' alt='product image'>"].join.html_safe
  end
end
