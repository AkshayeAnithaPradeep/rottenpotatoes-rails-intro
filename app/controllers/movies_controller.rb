class MoviesController < ApplicationController

  @@movies_class = nil
  @@checked_ratings = nil
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_all_ratings()
    @ratings = Hash.new
    if params[:ratings]
      @ratings = params[:ratings]
      @@checked_ratings = @ratings.keys
      @@movies_class = Movie.where(rating: @@checked_ratings)
    elsif @@checked_ratings
      @@checked_ratings.each do |rating|
        @ratings[rating] = 1
      end
    else
      @all_ratings.each do |rating|
        @ratings[rating] = 1
      end
    end
    if @@movies_class
      @movies = @@movies_class
    else
      @movies = Movie.all
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
    if !@@movies_class
      @@movies_class = Movie.all
    end
    if params[:format] == "sort_release"
      @@movies_class = @@movies_class.reorder(:release_date)
      puts "Here1"
    elsif params[:format] == "sort_title"
      @@movies_class = @@movies_class.reorder(:title)
      puts "Here2"
    end
    redirect_to movies_path()
  end

end
