Rails.application.routes.draw do
  scope "(:locale)", :locale => /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"
    get "/home", to: "static_pages#home"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/createquestion", to: "questions#new"
    post "/createquestion", to: "questions#create"
    get "/createcategory", to: "categories#new"
    post "/createcategory", to: "categories#create"
    get "/createlesson", to: "lessons#new"
    post "/createlesson", to: "lessons#create"
    get "/testlesson", to: "results#new"
    post "/testlesson", to: "results#create"
    
    resources :users, only: %i(show edit update)
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)
    resources :questions
    resources :categories
    resources :lessons
    resources :results

    namespace :admin do
      root "users#index"
      delete "/users/:id", to: "users#destroy",
        as: :destroy_user
      patch "users/:id", to: "users#update", as: :patch_user
      put "users/:id", to: "users#update", as: :put_user
      resources :users, except: %i(destroy update)
    end
  end
end
