class ReviewsController < ApplicationController
  before_filter :find_movie
  
  def create
    render :template => 'review/create'
  end
  
  private
    def find_movie
      @movie = Movie.find(params[:movie_id])
    end
end
