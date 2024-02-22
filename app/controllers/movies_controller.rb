class MoviesController < ApplicationController

  def create
    connection = Faraday.new(url: 'http://localhost:3001', headers: {'Content-Type' => 'application/json'})
    response = connection.post do |req|
      req.url '/movies.json'
      req.body = { movie: movie_params }.to_json
    end

    if response.success?
      flash[:notice] = "Film został utworzony"
      redirect_to root_path
    else
      flash[:alert] = "Film nie został utworzony"
      redirect_to new_movie_path
    end
  end

  def edit
    movie_id = params[:id]
    connection = Faraday.new(url: 'http://localhost:3001').get("/movies/#{movie_id}.json")
    @movie = JSON.parse(connection.body)
  end

  def update
    movie_id = params[:id]
    connection = Faraday.new(url: 'http://localhost:3001')
    response = connection.patch do |req|
      req.url "/movies/#{movie_id}.json"
      req.headers['Content-Type'] = 'application/json'
      req.body = { id: movie_id, movie: movie_params }.to_json
    end

    if response.success?
      flash[:notice] = "Film został zaktualizowany"
      redirect_to root_path
    else
      flash[:alert] = "Film nie został zaktualizowany"
      redirect_to new_movie_path
    end
  end

  def destroy
    movie_id = params[:id]
    connection = Faraday.new(url: 'http://localhost:3001')
    response = connection.delete("/movies/#{movie_id}.json")
    if response.success?
      flash[:notice] = "Film został usunięty"
      redirect_to root_path
    else
      flash[:alert] = "Film nie został usunięty"
      redirect_to root_path
    end
  end

  
  private

  def movie_params
    params.require(:movie).permit(:title, :description, :published)
  end

end