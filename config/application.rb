require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JlcInvest
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # In Rails 5 autoloading is disabled for production environment by default
    # Rails will load all the constants from eager_load_paths but if a constant is missing
    # then it will not look in autoload_paths and will not attempt to load the missing constant
    config.eager_load_paths << Rails.root.join('lib')

    I18n.config.enforce_available_locales = true
    config.i18n.default_locale = :fr

    config.generators do|g|
      g.test_framework :rspec,
        fixtures:         true,
        view_specs:       false,
        helper_specs:     false,
        routing_specs:    false,
        controller_specs: true,
        request_specs:    false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
