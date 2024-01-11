json.extract! article, :id, :title, :publisher, :pbulished_year, :created_at, :updated_at
json.url article_url(article, format: :json)
