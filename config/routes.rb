Spree::Core::Engine.add_routes do
  scope :account do
    get '/:tab', to: 'users#show', tab: /orders/

    get '/shipping', to: 'addresses#index', as: :user_addresses
    get '/shipping/edit', to: 'addresses#new', as: :new_address

    put '/password', to: 'users#update_password', as: :update_user_password
    get '/password', to: redirect('/account/edit') # fix 404 on page refresh after password change fail

    get '/payment', to: 'credit_cards#index', as: :user_payment_methods
    get '/payment/edit', to: 'credit_cards#new', as: :new_payment_method
    resources :credit_cards, except: %i[index show new]
  end

  post '/orders/rate/:id', to: 'orders#rate', as: :rate_order

  get '/taxons/mobile_menu_childs', to: 'taxons#mobile_menu_childs'

  resources :addresses, except: %i[index show new]
end

Rails.application.routes.draw do
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server_error'

  mount Spree::Core::Engine, at: '/'

  scope :freshdesk do
    get '/', to: 'freshdesk#login', as: :freshdesk
  end

  require 'sidekiq/web'
  authenticate :spree_user, ->(u) { u.admin? } do
    mount Sidekiq::Web, at: 'sidekiq'
    mount PgHero::Engine, at: 'pghero'
    mount Ckeditor::Engine, at: 'ckeditor'
  end

  resources :api_docs, path: 'apidocs', only: [:index] do
    collection do
      get :schema
    end
  end
end
