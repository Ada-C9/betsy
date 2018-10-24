module ApplicationHelper
  def average_rating(model)
    reviews = model.reviews

    return 0 if reviews.count == 0

    total = reviews.map do |rating|
      rating.rating
    end.sum.to_f

    return total / reviews.count
  end
end
