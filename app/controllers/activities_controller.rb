class ActivitiesController < ApplicationController
  def index
    @activities = Activity.for_movie(params[:movie_id])

    respond_to do |format|
      format.html { render :layout=> false }
      format.xml  { render :xml => @activities }
    end
  end
  
  def friend
    @activities = Activity.for_movie(params[:movie_id]).for_user(current_user)

    respond_to do |format|
      format.html { render :layout=> false, :action=> 'index' }
      format.xml  { render :xml => @activities }
    end
  end
end
