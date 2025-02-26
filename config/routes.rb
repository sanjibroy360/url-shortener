Rails.application.routes.draw do
  root "urls#index"
  resources :urls, except: [:destroy]
  get "/:short_code", to: "urls#redirect"
  delete "/urls/:short_code", to: "urls#destroy"
end
