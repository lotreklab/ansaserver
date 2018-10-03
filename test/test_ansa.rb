ENV['RACK_ENV'] = 'test'
require 'helper'

require 'ansa'
require "mocha/setup"
require 'time'
require 'rack/test'

require './server'


def generate_mocked_news
  mocked_news = [
    Ansa::News.new(
      'Title 2', 'Desc 2',
      Time.parse("2018-09-19 17:35:35 +0200"),
      'http://ansa.it/news/2'
    ),
    Ansa::News.new(
      'Title 1', 'Desc 1',
      Time.parse("2018-09-18 17:35:35 +0200"),
      'http://ansa.it/news/1'
    ),
    Ansa::News.new(
      'Title 3', 'Desc 3',
      Time.parse("2018-09-20 17:35:35 +0200"),
      'http://ansa.it/news/3'
    )
  ]
  return mocked_news
end

class AnsaNewsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_fetches_homepage
    mocked_news = generate_mocked_news()
    Ansa.stubs(:get_news).returns(mocked_news)
    get '/api/news/homepage'
    assert last_response.ok?
    assert_equal "Title 2", YAML.load(last_response.body)[0]['title']
  end

  def test_it_fetches_homepage_order_and_q
    Ansa.stubs(:get_news).returns(generate_mocked_news())
    get '/api/news/homepage?order_by=title'
    assert last_response.ok?
    assert_equal "Title 1", YAML.load(last_response.body)[0]['title']

    Ansa.stubs(:get_news).returns(generate_mocked_news())
    get '/api/news/homepage?order_by=-title'
    assert last_response.ok?
    assert_equal "Title 3", YAML.load(last_response.body)[0]['title']

    Ansa.stubs(:get_news).returns(generate_mocked_news())
    get '/api/news/homepage?order_by=date'
    assert last_response.ok?
    assert_equal "Title 1", YAML.load(last_response.body)[0]['title']

    Ansa.stubs(:get_news).returns(generate_mocked_news())
    get '/api/news/homepage?order_by=-date'
    assert last_response.ok?
    assert_equal "Title 3", YAML.load(last_response.body)[0]['title']

    Ansa.stubs(:get_news).returns(generate_mocked_news())
    get '/api/news/homepage?order_by=-wrongpar'
    assert last_response.ok?
    assert_equal "Title 2", YAML.load(last_response.body)[0]['title']

    Ansa.stubs(:get_news).returns(generate_mocked_news())
    get '/api/news/homepage?q=Title'
    assert last_response.ok?
    assert_equal "Title 2", YAML.load(last_response.body)[0]['title']
    assert_equal 3, YAML.load(last_response.body).length

    Ansa.stubs(:get_news).returns(generate_mocked_news())
    get '/api/news/homepage?q=Title 2'
    assert last_response.ok?
    assert_equal "Title 2", YAML.load(last_response.body)[0]['title']
    assert_equal 1, YAML.load(last_response.body).length

    Ansa.stubs(:get_news).returns(generate_mocked_news())
    get '/api/news/homepage?q=nothing'
    assert last_response.ok?
    assert_equal 0, YAML.load(last_response.body).length
  end

  def test_it_fetches_wrong_category
    get '/api/news/home'
    assert_equal false, last_response.ok?
    assert_equal "{\"error\":\"Category not supported\"}", last_response.body
  end
end
