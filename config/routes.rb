Rails.application.routes.draw do
  
  resources :animals
  resources :regions
  resources :sightings
  
  root 'animals#index'

end
