class MediasController < ApplicationController
  before_filter :get_parent

  def sort
    params[:medias].each_with_index do |media, index|
      Media.update(media, { :position=> index })
    end
  end
  
  def create
    @media = @movie.medias.new(params[:media])
    @media.save
  end
  
  def destroy
    @media = @movie.medias.find(params[:id])
    @media.destroy
  end

  private
    def get_parent
      @movie = Movie.find(params[:movie_id])
    end
end