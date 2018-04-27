module ApplicationHelper

  def render_date(date)
    date.strftime("%b %e, %Y")
  end

  def image_url(product)
    ["<img src=", product.url, " alt=", product.name,">"].join.html_safe
  end

end
