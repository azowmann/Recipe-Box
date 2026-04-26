Rails.application.routes.draw do
  devise_for :users
  resources :recipes
  get "my_meal_plan", to: "meal_plans#current", as: :my_meal_plan
  resources :meal_plans, only: [:show, :create] do
    resource :shopping_list, only: [:show]
    resources :meal_plan_entries, only: [:create, :destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "recipes#index"
end
