module ProductsHelper
  def display_image(photo_url)
    ["<img src='", photo_url, "' alt='product image'>"].join.html_safe
  end
end
