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
    @all_ratings = Movie.ratings
    
    @sorted_column = params[:sort_by] || session[:sort]
    
    session[:ratings] = session[:ratings] || @all_ratings
    
    @rating_param = params[:ratings] || session[:ratings]
    
    session[:sort] = @sorted_column
    
    session[:ratings] = @rating_param
    
    
    #params[:ratings].nil? ? rating_param = @all_ratings : rating_param  = params[:ratings].keys
    @movies = Movie.where(rating:session[:ratings].keys).order(session[:sort])
    
    if (params[:sort_by].nil? and !(session[:sort].nil?)) or (params[:ratings].nil? and !(session[:ratings].nil?))
      flash.keep
      redirect_to movies_path(sort_by: session[:sort], ratings:session[:ratings])
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
