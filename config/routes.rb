Rails.application.routes.draw do
  root to: 'boxes#index'
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :boxes, only: [:new, :create, :index, :show] do
    resources :openings, only: [:create]
  end

  post "/refresh_position" => "positions#update"
end
