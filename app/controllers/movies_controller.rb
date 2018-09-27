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
    @all_ratings = Movie.get_all_ratings() #retrieve all possible ratings
    if params["ratings"]
      session[:ratings] = params["ratings"]
      session[:ratings].each do |rating|
        @ratings[rating[0]] = 1           #persist checkmark on checkbox for next render
      end
    elsif session[:ratings]
      params["ratings"] = session[:ratings]
      flash.keep
      redirect_to movies_path(params)
    else
      @all_ratings.each do |rating|
        @ratings[rating] = 1        #default case - all boxes checked
      end
    end
    @movies = Movie.where(rating: @ratings.keys).order(session[:sort])  #sorted and filtered movie list
    if session[:sort] == 'title'
      @title_class = "hilite"
    elsif session[:sort] == 'release_date'
      @release_class = "hilite"         #set hselected header to yellow color
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
    #set session hash value for selected sort type
    if params[:format] == "sort_release"
      session[:sort] = :release_date
    elsif params[:format] == "sort_title"
      session[:sort] = :title
    end
    redirect_to movies_path(params)
  end

end
