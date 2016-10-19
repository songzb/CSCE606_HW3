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
 ############################ PART 2 and PART3    
  @all_ratings = Movie.put_ratings
    
     if params[:commit] == 'Refresh'
    
      params[:sort_order] = nil
      session[:sort_order] = nil
      
      if params[:ratings]
        @ratings_filter = params[:ratings].keys
      else
        @ratings_filter=@all_ratings
      end
    else
       if session[:ratings]
          @ratings_filter=session[:ratings]
        else
          @ratings_filter = @all_ratings
        end
     
    end
      
      if @ratings_filter!=session[:ratings]
      session[:ratings] = @ratings_filter
      end
      
      if  params[:sort_order]!= nil && params[:sort_order] != session[:sort_order]
        session[:sort_order] = params[:sort_order]
      end
      
      if params[:sort_order] == nil && session[:sort_order]!=nil
         params[:sort_order] = session[:sort_order]
      end
   ###################################    
      
        #######   PART1
    if 'by_title' == params[:sort_order] || 'by_title' == session[:sort_order]
       @movies = Movie.order(:title)
    elsif 'by_release_date' == params[:sort_order] || 'by_release_date' == session[:sort_order]
      @movies = Movie.order(:release_date)
    elsif params[:sort_order].nil?
      @movies = Movie.all
    end
        #######
      @movies = @movies.ratingfilter(@ratings_filter)
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
