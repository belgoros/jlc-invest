require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module JlcInvest
  class Application < Rails::Application
    config.autoload_paths += %W(#{Rails.root}/lib)
    I18n.config.enforce_available_locales = true
    config.i18n.default_locale = :fr
  end
end
