Spree::Core::Engine.add_routes do
  scope :account do
    get '/:tab', to: 'users#show', tab: /orders|payment|shipping/
    put '/address', to: 'users#update_address', as: :update_address

    put '/password', to: 'users#update_password', as: :update_user_password
    get '/password', to: redirect('/account/edit') # fix 404 on page refresh after password change fail

    get '/payment/edit', to: 'credit_cards#new', as: :new_payment_method

    resources :credit_cards, only: %i[create destroy]
  end
end

Rails.application.routes.draw do
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server_error'

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
