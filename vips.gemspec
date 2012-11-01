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

  gem.add_dependency 'selenium-webdriver'
  gem.add_dependency 'watir'
  gem.add_dependency 'headless'
  gem.add_dependency 'thor'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'
end
