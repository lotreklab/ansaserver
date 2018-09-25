ENV['RACK_ENV'] = 'test'
require 'helper'

require 'ansa'
require "mocha/setup"
require 'time'
require 'rack/test'

require './server'


class AnsaNewsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_fetches_homepage
    mocked_news =[
      Ansa::News.new(
        'Title 1', 'Desc 1',
        Time.parse("2018-09-20 17:35:35 +0200"),
        'http://ansa.it/news/1'
      ),
      Ansa::News.new(
        'Title 2', 'Desc 2',
        Time.parse("2018-09-19 17:35:35 +0200"),
        'http://ansa.it/news/2'
      ),
      Ansa::News.new(
        'Title 3', 'Desc 3',
        Time.parse("2018-09-18 17:35:35 +0200"),
        'http://ansa.it/news/3'
      )
    ]
    Ansa.stubs(:get_news).returns(mocked_news)
    get '/api/news/homepage'
    assert last_response.ok?
  end

  def test_it_fetches_wrong_category
    get '/api/news/home'
    assert_equal false, last_response.ok?
  end
end
