module ApplicationHelper

  def format_price(price)
    ("<span>" + number_to_currency(price) + "</span>").html_safe
  end

end
