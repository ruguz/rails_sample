Rails.application.routes.draw do
  namespace :api do
    namespace :user do
      post :check
      post :register
    end
  end
end
