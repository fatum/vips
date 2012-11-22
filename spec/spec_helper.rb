# -*- encoding : utf-8 -*-
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

$: << File.expand_path('../lib', __FILE__)
require 'rubygems'
require 'bundler/setup'

require 'vips'

Bundler.require

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
