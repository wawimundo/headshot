$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "headshot/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "headshot"
  s.version     = Headshot::VERSION
  s.authors     = ["Diwa del Mundo"]
  s.email       = ["diwadm@gmail.com"]
  s.homepage    = "http://headshot.hypermediasoft.com"
  s.summary     = "Easy web cam integration for Ruby on Rails."
  s.description = "Headshot provides a quick and easy way for Ruby on Rails applications to capture users's photos via a web camera."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "paperclip"
end
