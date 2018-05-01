module ProductsHelper
  def average_rating(product)
    reviews = product.reviews

    review_count = reviews.count

    ratings = reviews.map { |review| review.rating}
    ratings_sum = ratings.inject { |sum, rating| sum + rating }


    return (ratings_sum.to_f / review_count.to_f).round(2) if !ratings_sum.nil?
  end
end
