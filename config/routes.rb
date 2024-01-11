# frozen_string_literal: true

Rails.application.routes.draw do
  get 'search_histories/index'
  resources :articles
  root 'articles#index'
end
