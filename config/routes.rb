Rails.application.routes.draw do
  root to: 'pages#index'
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  # Create a box
    # get "boxes/new" => "boxes#new"
    # post "boxes" => "boxes#create"

  # Read all the boxes
    # get "boxes" => "boxes#index"

  # Read a box
    # get "boxes/:id" =>"boxes#show"


  # Open the box
    # post "boxes/:id/openings" => "openings#create"

  # afficher le contenu de la boite et pouvoir la noter
    # get "openings/:id/edit" => "openings#edit"
    # patch "openings/:id/update" => "openings#update"

  resources :boxes, only: [:new, :create, :index, :show] do
    resources :openings, only: [:create]
  end
  resources :openings, only: [:edit, :update]

end
