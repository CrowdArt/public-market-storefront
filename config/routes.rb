Spree::Core::Engine.add_routes do
  get '/account/:tab', to: 'users#show', tab: /orders|payment/
  put '/account/address', to: 'users#update_address', as: :update_address
end

Rails.application.routes.draw do
  mount Spree::Core::Engine, at: '/'

  require 'sidekiq/web'
  authenticate :spree_user, ->(u) { u.admin? } do
    mount Sidekiq::Web, at: 'sidekiq'
    mount PgHero::Engine, at: 'pghero'
  end

  resources :api_docs, path: 'apidocs', only: [:index] do
    collection do
      get :schema
    end
  end
end
