class Review::ImdbReviewsController < ReviewsController
  def create
    @review = @movie.imdb_movie_review || Review::ImdbReview.new(:movie_id=> @movie.id)
    @review.update_with_url(params[:value])
    @review.save
    super
  end
end