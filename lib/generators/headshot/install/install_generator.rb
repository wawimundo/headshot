require 'rails'

if ::Rails.version < '3.1' || !::Rails.application.config.assets.enabled
  module Headshot
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        desc "This generator install the Headshot assets (JavaScript, Audio, and Flash application files)."
        source_root File.expand_path('../../../../../lib/assets', __FILE__)
      end

      def copy_javascripts
        say_status('copying', 'Copying Javascripts ...')
      end
    end
  end
else
  module Headshot
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        desc "Asset pipeline enabled."
      end
    end
  end
end