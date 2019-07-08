Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/posts', to: 'posts#index'
      # post '/trainers', to: 'trainers#create'
      # post '/trainers/:id', to: 'trainers#update'
      # get '/pokemons', to: 'pokemons#index'
      # get '/trainers', to: 'trainers#index'
    end
  end
end
