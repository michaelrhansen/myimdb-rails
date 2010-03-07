class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.xml
  def index
    search_query  = params[:q].try(:strip).try(:downcase)
    @movies       = Movie.locate(:page=> params[:page], :q=> search_query)

    if @movies.empty?
      @alternative_movie_name = Movie.spell(search_query) 
      @alternative_movies     = Movie.find_all_by_name(@alternative_movie_name) if @alternative_movie_name
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @movies }
    end
  end
  
  def fuzzy
    @movies = Movie.locate(:page=> params[:page], :q=> params[:q], :fuzzy=> true)

    respond_to do |format|
      format.html { render :layout=> false }
      format.xml  { render :xml => @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    unless handle_mood
      @movie = Movie.find(params[:id])

      respond_to do |format|
        format.html { render :layout=> false }
        format.xml  { render :xml => @movie }
      end
    end
  end

  # GET /movies/new
  # GET /movies/new.xml
  def new
    @movie = Movie.new(:name=> params[:name], :imdb_id=> params[:imdb_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.xml
  def create
    @movie = Movie.new(params[:movie])

    respond_to do |format|
      if @movie.save
        flash[:notice] = 'Movie was successfully created.'
        format.html { redirect_to(movies_path) }
        format.xml  { render :xml => @movie, :status => :created, :location => @movie }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.xml
  def update
    @movie = Movie.find(params[:id])

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        flash[:notice] = 'Movie was successfully updated.'
        format.html { redirect_to(@movie) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.xml
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to(movies_url) }
      format.xml  { head :ok }
    end
  end

  def autofill
    @imdb_result        = Review::ImdbReview.locate(params[:title])
    @metacritic_result  = Review::MetacriticReview.locate(params[:title])

    render :layout=> false
  end

  def handle_mood
    mood = params[:id]
    if status =  MovieStatus::Statuses.detect{ |_,status_data| status_data[:association] == mood }
      @movies = current_user.send(mood)
      render :action=> 'index'
    end
  end

end
