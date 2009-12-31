ActionController::Routing::Routes.draw do |map|
  map.resources :people

  map.resources :relationships
  map.resources :movie_statuses
  map.resources :activities
  
  map.resources :movies, :collection=> { :autofill=> :post } do |movie|
    movie.namespace :review do |review|
      review.resource :imdb_review
      review.resource :metacritic_review
      review.resource :rotten_tomatoes_review
    end
    movie.resources :activities, :collection=> { :friend=> :get }
    movie.resources :medias, :collection=> { :sort=> :put }
  end

  map.resource  :session, :member=> { :register=> :get, :create=> :get }
  map.resource  :home
  map.resources :users, :collection=> { :follow_status=> :get }

  map.root :controller => "homes", :action=> 'index'
  
  map.public_profile ':username', :controller=> 'homes', :action=> 'public'
end
