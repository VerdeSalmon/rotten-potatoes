class MoviesController < ApplicationController

  include MoviesHelper
  # include Tmdb

  def index
    @coming_soon = Tmdb::Movie.upcoming.results
    @in_theaters = Tmdb::Movie.now_playing.results
    @genres = Tmdb::Genre.movie_list
    @all_movies = (@coming_soon + @in_theaters).uniq
    if params[:search]
      @found_movies = []
      @all_movies.each do |movie|
        @movie_details = Tmdb::Movie.detail(movie.id)
        if @movie_details.title.downcase.include?(params[:search].downcase)
          @found_movies << @movie_details
        end
      end
    end
  end

  def show
    @movie = Tmdb::Movie.detail(params[:id])
    @reviews = Movie.find_by(api_id: @movie.id).reviews
  end
end
