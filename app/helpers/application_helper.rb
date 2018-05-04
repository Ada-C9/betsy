module ApplicationHelper

  def render_date(date)
    date.strftime("%b %e, %Y")
  end

  def format_price(price)
    if price.nil?
      price = 0
    end

    "$" + format("%.2f", price/100)
  end

  def render_stars(value)
    output = ''
    if (1..5).include?(value.to_i)
      value.to_i.times { output += image_tag("star.png", class: "style-image")}
    end
    output.html_safe
  end
end
