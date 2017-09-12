Rails.application.routes.draw do
  scope '4nDWwolPHNbRMjfoT5Ni/calendrier' do
    root to: 'events#index'
    devise_for :users

    resources :events, only: [:index] do
      resources :inscriptions, only: [:show, :new, :create, :destroy]
    end

    resources :commentaires, only: [:new, :create, :edit, :update]
    get 'events/index'
    post 'inscriptions/login', to: 'inscriptions#login', as: 'my_login'
    get 'inscriptions/logout', to: 'inscriptions#logout', as: 'my_logout'
    get 'questions-reponses', to: 'events#faq', as: 'faq'

    namespace :admin do
      root to: 'events#index'
      get 'events/index'
      resources :events, only: [:index] do
        resources :inscriptions, only: [:edit, :update, :destroy]
      end
      get 'inscriptions/export', to: 'inscriptions#export', as: 'inscriptions_export'
      get 'filldb', to: 'events#custom_action'
      match 'auto-emails', to: 'events#auto_emails', via: [:get, :post]
    end
  end
end
