require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Kanjime
  class Application < Rails::Application
  	config.assets.paths += Dir["#{Rails.root}/vendor/details-wrap/*"]
  	
     # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"
    
    # Heroku REQUIRES this to be false
    config.assets.initialize_on_precompile = false
  end
end
