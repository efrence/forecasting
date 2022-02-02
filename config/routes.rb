Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :forecasting, controller: 'forecasting', only: [:new] do
    get :current_weather, on: :member, constraints: { format: 'json' }
  end

  # Defines the root path route ("/")
  root "forecasting#new"
end
