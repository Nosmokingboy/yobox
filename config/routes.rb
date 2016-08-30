Rails.application.routes.draw do
  root to: 'boxes#index'
  get 'stats', to: 'users#stats'
  post "/refresh_position" => "positions#update"

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :boxes, only: [:new, :create, :index, :show] do
    member do
      post 'preview'
    end
    resources :openings, only: [:create]
  end

end
