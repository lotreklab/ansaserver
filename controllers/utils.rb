def ansa_news_to_json(news_array)
  json_array = []
  news_array.each do |news|
    json_array.append({
      title: news.title
    })
  end
  return json_array
end


def order_by(news_array, criteria)

end


def search(news_array, q)

end
