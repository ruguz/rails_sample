require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sample
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    # load lib
    config.autoload_paths << Rails.root.join('lib')

    # load routes
    %i[api admin].each do |route|
      config.paths["config/routes.rb"] << Rails.root.join("config", "routes", "#{route}.rb" )
    end
  end
end
