class MovieStatusesController < ApplicationController
  before_filter :get_movie

  def toggle
    MovieStatus.toggle(:movie_id=> @movie.id, :status_id=> params[:id], :user_id=> current_user.id)

    respond_to do |format|
      format.js
      format.xml  { head :ok }
    end
  end
  
  private
    def get_movie
      @movie = Movie.find(params[:movie_id])
    end
end
