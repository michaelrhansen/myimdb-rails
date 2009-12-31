class Review::RottenTomatoesReviewsController < ReviewsController
  def create
    @review = @movie.rotten_tomatoes_movie_review || Review::RottenTomatoesReview.new(:movie_id=> @movie.id)
    @review.update_with_url(params[:value])
    @review.save
    super
  end
  
end