require 'rails'
require 'rails/generators/migration'

module Headshot
  module Generators
    class GenerateGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      desc "This generator creates the template controllers, models, helpers, routes, and migrations."
      source_root File.expand_path('../../../../../', __FILE__)

      # Copied migration template generator from http://stackoverflow.com/questions/4141739/generators-and-migrations-in-plugins-rails-3
      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def add_headshot_routes
        route %{post "headshot/capture" => 'headshot#capture', :as => :headshot_capture}
      end

      def create_model_file
        template "lib/app/models/headshot_photo.rb", "app/models/headshot_photo.rb"
        migration_template "lib/db/migrate/create_headshot_photos.rb", "db/migrate/create_headshot_photos.rb"
      end
    end
  end
end