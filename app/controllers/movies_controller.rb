class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    # Filtering:
    if params.has_key?(:ratings)
      @ratings = params[:ratings]
      session[:ratings] = @ratings
    elsif session.has_key?(:ratings)
      @ratings = session[:ratings]
    else
      # Convert the array @all_ratings to a Hash to compare 
      # with the Hash from param[:ratings]
      @ratings = Hash[@all_ratings.collect { |k| [k, 1] } ]
    end

    @movies = Movie.where(rating: @ratings.keys)

    # Ordering:
    sort = params[:sort]
    if sort == 'title'
      @sorted_by = 'title'
      session[:sorted_by] = @sorted_by
    elsif sort == 'release_date'
      @sorted_by = 'release_date'
      session[:sorted_by] = @sorted_by
    else
      @sorted_by = session[:sorted_by]
    end

    @movies = @movies.order(@sorted_by)

    # Verify the URI with the Session filter/order for redirect 
    # to the same URI with correct params.
    if params[:sort] != session[:sorted_by] || params[:ratings] != session[:ratings]
      session[:sort]    = @sorted_by
      session[:ratings] = @ratings
      flash.keep
      redirect_to :sort => @sorted_by, :ratings => @ratings and return
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
