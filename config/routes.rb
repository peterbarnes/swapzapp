Swapzapp::Application.routes.draw do
  
  namespace :api, :defaults => {:format => 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resource  :account, :only => [:show] do
        get 'metadata'
      end
      resources :certificates
      resources :customers
      resources :inventories
      resources :items
      resources :locations
      resources :purchases
      resources :repairs
      resources :reports
      resources :sales
      resources :stores
      resources :templates
      resources :tills do
        member do
          get 'metadata'
        end
      end
      resources :timecards
      resources :units
      resources :users do
        collection do
          get 'authenticate'
        end
      end
    end
  end
  
  scope "/account", module: "account" do
    resource :account, :only => [:edit, :update], :controller => :account do
      member do
        get 'regenerate'
      end
    end
    resources :stores do
      collection do
        get 'state'
      end
    end
    resources :templates
    resources :users
  end
  
  resources :activities, :only => [:index]
  
  scope "/inventory", module: "inventory" do
    resources :inventories, :except => [:show]
    resources :items
    resources :locations
    resources :units
  end
  
  scope "/operation", module: "operation" do
    resources :certificates do
      member do
        get 'activate'
        get 'print'
        get 'template'
      end
    end
    resources :customers do
      member do
        get 'print'
        get 'template'
      end
      collection do
        get 'state'
      end
    end
    resources :purchases, :only => [:index, :show, :destroy] do
      collection do
        get 'trend'
      end
      member do
        get 'flag'
        get 'print'
        get 'template'
      end
    end
    resources :repairs, :only => [:index, :show, :destroy] do
      member do
        get 'flag'
        get 'print'
        get 'template'
      end
    end
    resources :sales, :only => [:index, :show, :destroy] do
      collection do
        get 'trend'
      end
      member do
        get 'flag'
        get 'print'
        get 'template'
      end
    end
  end
  
  resources :reports, :only => [:index, :new, :create, :destroy] do
    member do
      get 'regenerate'
      get 'download'
    end
  end
  resources :tills do
    resources :adjustments, :only => [:index, :new, :create]
    resource :transfer, :only => [:new, :create]
    member do
      get 'release'
    end
  end
  resources :timecards, :except => [:show] do
    member do
      get 'flag'
      get 'clockout'
    end
  end
  
  get 'dashboard' => 'dashboard#index'
  get 'pos' => 'pos#index'
  
  get 'login' => 'session#login'
  post 'login' => 'session#login_create'
  get 'logout' => 'session#login_destroy'
  get 'recover' => 'session#recover'
  post 'recover' => 'session#recover_process'
  get 'reset' => 'session#reset'
  post 'reset' => 'session#reset_process'
 
  root :to => 'dashboard#index'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
