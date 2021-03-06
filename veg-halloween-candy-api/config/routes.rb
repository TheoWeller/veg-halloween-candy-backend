Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      #POSTS
      get '/posts', to: 'posts#index'
      post '/posts/create', to: 'posts#create'
      post '/posts/edit', to: 'posts#update'
      post '/posts/delete', to: 'posts#delete'
      post '/posts/save', to: 'posts#save_draft'

      #USERS
      post '/signup', to: 'users#create'
      post '/login', to: 'users#login'
      post '/auto_login', to: 'users#auto_login'
    end
  end
end
