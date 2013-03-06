# FbAccount

Facebook rails helper for accounts. Useful for facebook tabs and canvases.

## Installation

Add this line to your application's Gemfile:

    gem 'fb-account'

## Usage

Set Facebook app configuration
    
    # config/initializers/fb_account.rb
    FbAccount::Config.configure do |config|
      config.app_id = "app_id"
      config.app_secret = "app_secret"
    end

Include FbAccount helper to application controller
    
    # app/controllers/application_controller.rb
    class ApplicationController < ActionController::Base
      include FbAccount::Helper

Include FbAccount model to your account model

    # app/models/account.rb
    class Account < ActiveRecord::Base
      include FbAccount::Model

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request