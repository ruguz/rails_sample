Rails.application.routes.draw do
  devise_for :admin_users, only: [:session], path: '/admin',
                           path_names: {:sign_in => 'login', :sign_out => 'logout'}
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
