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

    if params.has_key?(:ratings)
      @ratings = params[:ratings].keys
      @movies  = Movie.where(rating: @ratings)
    else
      @ratings = @all_ratings
      @movies  = Movie.all
    end

    sort = params[:sort]
    if sort == 'title'
      @movies = @movies.order(:title)
      @sorted_by = 'title_header'
    elsif sort == 'date'
      @movies = @movies.order(:release_date)
      @sorted_by = 'release_date_header'
    else
      @sorted_by = nil
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
