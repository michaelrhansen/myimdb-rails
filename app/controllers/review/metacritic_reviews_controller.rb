class Review::MetacriticReviewsController < ReviewsController
  def create
    @review = @movie.metacritic_movie_review || Review::MetacriticReview.new(:movie_id=> @movie.id)
    @review.update_with_url(params[:value])
    @review.save
    super
  end
  
end