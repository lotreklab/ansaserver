def ansa_news_to_json(news_array)
  json_array = []
  news_array.each do |news|
    json_array.append({
      title: news.title,
      date: news.date,
      description: news.description,
      link: news.link
    })
  end
  return json_array
end


def need_swap(el1, el2, criteria)
  if criteria == '-date' then
    return el1.date < el2.date
  elsif criteria == 'date' then
    return el1.date > el2.date
  elsif criteria == '-title' then
    return el1.title < el2.title
  elsif criteria == 'title' then
    return el1.title > el2.title
  end
end


def order_by(news_array, criteria)
  if not criteria then
    return news_array
  end
  if not ["date", "-date", "title", "-title"].include?(criteria) then
    return news_array
  end
  n = news_array.length
  loop do
    swapped = false
    (1..n-1).each do |i|
      if need_swap(news_array[i-1], news_array[i], criteria) then
        aux = news_array[i-1]
        news_array[i-1] = news_array[i]
        news_array[i] = aux
        swapped = true
      end
    end
    if not swapped then
      break
    end
  end
  return news_array

end


def search(news_array, q)
  if not q then
    return news_array
  end
  news_array.delete_if do |news|
    not (news.title + news.description).include? q
  end
  return news_array
end
