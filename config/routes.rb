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
