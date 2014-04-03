require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module JlcInvest
  class Application < Rails::Application
    config.autoload_paths += %W(#{Rails.root}/lib)
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
