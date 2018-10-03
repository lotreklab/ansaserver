require 'sinatra'
require "sinatra/json"

require 'ansa'
require './controllers/utils'


get '/api/news/:category' do
  orderby = params[:order_by]
  query = params[:q]
  begin
    all_the_news = Ansa::get_news(params[:category])
    status 200
    body json ansa_news_to_json(
      order_by(
        search(all_the_news, query),
        orderby
      )
    )
  rescue Ansa::AnsaError
    status 400
    body json :error => "Category not supported"
  end

end
