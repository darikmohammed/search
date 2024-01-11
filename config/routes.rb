Rails.application.routes.draw do
  get 'search_histories/index'
  resources :articles
  root 'articles#index'
end
