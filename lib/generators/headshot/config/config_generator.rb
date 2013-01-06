require 'rails'

module Headshot
  module Generators
    class ConfigGenerator < ::Rails::Generators::Base
      desc "This generator configures the application so it would be able to communicate with the Headshot Flash binary."
      source_root File.expand_path('../../../../../lib/assets', __FILE__)

      def copy_flash_middleware
        say_status('copying', 'Copying Flash session cookie middleware ...')
        begin
          say_status('creating', 'Creating directory app/middlewares.')
          Dir.mkdir('app/middlewares')
        rescue Errno::EEXIST => e
          say('Directory app/middlewares exists!')
        end

        copy_file('../middlewares/flash_session_cookie_middleware.rb', 'app/middlewares/flash_session_cookie_middleware.rb')
      end
    end
  end
end