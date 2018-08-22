Rails.application.routes.draw do
  scope "(:locale)", :locale => /#{I18n.available_locales.join("|")}/ do
    root "users#index"
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
    
    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)
    resources :questions
    resources :categories
    resources :lessons
    resources :results
  end
end
