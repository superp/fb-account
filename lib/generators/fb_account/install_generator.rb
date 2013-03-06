require 'rails/generators'

module FbAccount
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Creates a FbAccount initializer and copy general files to your application."
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
              
      def copy_configurations
        copy_file("config/fb_account.rb", 'config/initializers/fb_account.rb')        
      end
      
      # copy models
      def copy_models
        copy_file("models/account.rb", 'app/models/account.rb')
      end
    end
  end
end
