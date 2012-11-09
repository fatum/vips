$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib/'))

require 'bundler/setup'

Bundler.require

require 'vips/app/server'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'lib/vips/app/assets/javascripts'

  run environment
end

map '/' do
  run Server
end
