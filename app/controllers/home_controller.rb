class HomeController < ApplicationController
  def index
    response = connection.get('/movies.json')
    @body = JSON.parse(response.body)
  end

  private

  def connection
    @connection ||= Faraday.new(url: 'http://localhost:3001')
  end
end
