Rails.application.routes.draw do
  scope "(:locale)", :locale => /#{I18n.available_locales.join("|")}/ do
    root "users#index"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users
  end
end
