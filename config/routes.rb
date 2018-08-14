Spree::Core::Engine.routes.draw do
  get 'products/top-selling', to: 'products#top_selling'
end

Spree::Core::Engine.add_routes do
  namespace :admin, path: Spree.admin_path do
    resources :product_collections
  end

  scope :account do
    get '/(:tab)', to: 'users#show', tab: /orders/, as: :account

    get '/shipping', to: 'addresses#index', as: :user_addresses
    get '/shipping/edit', to: 'addresses#new', as: :new_address

    put '/password', to: 'users#update_password', as: :update_user_password
    get '/password', to: redirect('/account/edit') # fix 404 on page refresh after password change fail

    get '/payment', to: 'credit_cards#index', as: :user_payment_methods
    get '/payment/edit', to: 'credit_cards#new', as: :new_payment_method

    resources :credit_cards, except: %i[index show new]
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      get '/orders/fetch', to: 'orders#fetch'
      post '/orders/update', to: 'orders#update_items'
      put '/shipments/:id/cancel_item', to: 'shipments#cancel_item'
      put '/shipments/:id/confirm_item', to: 'shipments#confirm_item'
    end
  end

  scope :orders do
    get '/:id/rate/:shipment_id', to: 'orders#rate_shipment', as: :rate_shipment
    post '/:id/rate/:shipment_id', to: 'orders#update_shipment_rate', as: :update_shipment_rate
  end

  get '/products/:id/variation/:variation', to: 'products#similar_variants', as: :similar_variants

  get '/taxons/mobile_menu_childs', to: 'taxons#mobile_menu_childs'

  get '/top-selling', to: 'products#best_selling'
  get '/top-selling/t/*id/', to: 'products#best_selling', as: :top_selling_taxon
  get '/staff-picks', to: 'products#staff_picks'

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
  require 'sidekiq-scheduler/web'
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
