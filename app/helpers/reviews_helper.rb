module ReviewsHelper
  def stars (rating_num)
    stars = " "
    rating_num.to_i.times do
      stars += "★"
    end
    return stars
  end
end
