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

      def load_middlewares_in_application_rb
        application_rb_path = "config/application.rb"
        code_marker = "class Application < Rails::Application"
        loading_code = 'config.autoload_paths += %W(#{config.root}/app/middlewares)'
        say_status('checking', 'Checking if application.rb contains the loading code for the middleware.')

        application_rb = IO.readlines(application_rb_path)
        application_rb_lines = application_rb.join('')
        # application_rb_lines =~ /config\.autoload_paths \+= \%W\(\#\{config\.root\}\/app\/middlewares\)/
        if application_rb_lines.include?(loading_code)
          say('Middlewares are being loaded already.')
        else
          say_status('modifying', 'Inserting code for loading middlewares.')
          application_rb_lines.sub!(code_marker, "#{code_marker}\n\t\t#{loading_code}")

          application_rb_file = File.open(application_rb_path, "w")
          application_rb_file.write(application_rb_lines)
          application_rb_file.close
        end
      end
    end
  end
end