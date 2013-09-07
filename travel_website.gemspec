$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "travel_website/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "travel_website"
  s.version     = TravelWebsite::VERSION
  s.authors     = ["Jimmy Liang"]
  s.email       = ["solo123@21cn.com"]
  s.homepage    = "http://github.com/solo123"
  s.summary     = "Summary of TravelWebsite."
  s.description = "Description of TravelWebsite."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
