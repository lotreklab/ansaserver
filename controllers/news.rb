require 'sinatra'
require "sinatra/json"

require 'ansa'
require './controllers/utils'


get '/api/news/:category' do
  orderby = params[:orderby]
  query = params[:q]
  begin
    all_the_news = Ansa::get_news(params[:category])
    status 200
    body json ansa_news_to_json(all_the_news)
  rescue Ansa::AnsaError
    status 400
    body json :error => "Category not supported"
  end

end
