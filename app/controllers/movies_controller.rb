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
    @ratings = Hash.new
    @all_ratings = Movie.get_all_ratings()
    if params["ratings"]
      session[:ratings] = params["ratings"]
      session[:ratings].each do |rating|
        @ratings[rating[0]] = 1
      end
    elsif session[:ratings]
      session[:ratings].each do |rating|
        @ratings[rating[0]] = 1
      end
    else
      @all_ratings.each do |rating|
        @ratings[rating] = 1
      end
    end
    @movies = Movie.where(rating: @ratings.keys).order(session[:sort])
    if session[:sort] == 'title'
      print "Here"
      @title_class = "hilite"
    elsif session[:sort] == 'release_date'
      print "Or here"
      @release_class = "hilite"
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
  
  def sort
    if params[:format] == "sort_release"
      session[:sort] = :release_date
    elsif params[:format] == "sort_title"
      session[:sort] = :title
    end
    redirect_to movies_path()
  end

end
