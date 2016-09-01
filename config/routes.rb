Rails.application.routes.draw do
  root to: 'boxes#index'
  get 'stats', to: 'users#stats'
  get 'report', to: 'boxes#report'
  post "/refresh_position" => "positions#update"
  patch 'rating', to: 'box#opening'

  devise_for :users,
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

  resources :boxes, only: [:new, :create, :show] do
    member do
      post 'preview'
    end
    resources :openings, only: [:update], shallow: true
  end

end
