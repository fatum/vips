# -*- encoding : utf-8 -*-
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

$: << File.expand_path('../lib', __FILE__)
require 'rubygems'
require 'bundler/setup'
require 'vips'

Bundler.require

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros

  config.mock_with :rspec

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  VCR.configure do |c|
    c.default_cassette_options = {
      :update_content_length_header => true,
      :allow_playback_repeats => true
    }

    c.allow_http_connections_when_no_cassette = true
    c.configure_rspec_metadata!
    c.cassette_library_dir = 'spec/cassettes'
    c.hook_into :webmock
  end
end
