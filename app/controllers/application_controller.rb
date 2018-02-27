class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  attr_accessor :current_admin_user
end
