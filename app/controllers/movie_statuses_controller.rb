class MovieStatusesController < ApplicationController
  def create
    if @movie_status = MovieStatus.find_by_status_id_and_movie_id_and_user_id(
      params[:movie_status][:status_id], 
      params[:movie_status][:movie_id], 
      current_user.id)
      @movie_status.destroy
    else
      @movie_status = MovieStatus.new(params[:movie_status].merge(:user=> current_user))
      @movie_status.save
    end

    respond_to do |format|
      format.js
      format.xml  { head :ok }
    end
  end
end
