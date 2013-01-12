require 'active_support/dependencies'

%w{controllers helpers lib}.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.autoload_paths << path
end

module Headshot
end
