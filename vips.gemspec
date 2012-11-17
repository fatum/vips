# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vips/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["m.filippovich"]
  gem.email         = ["fatumka@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vips"
  gem.require_paths = ["lib"]
  gem.version       = Vips::VERSION

  gem.add_dependency 'rest-client'
  gem.add_dependency 'colored'
  gem.add_dependency 'thor'
  gem.add_dependency 'thin'
  gem.add_dependency 'sinatra'
  gem.add_dependency 'sprockets'
  gem.add_dependency 'coffee-script'
  gem.add_dependency 'therubyracer'
  gem.add_dependency 'haml'
  gem.add_dependency 'json'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'shotgun'
  gem.add_development_dependency 'rack-test'
end
