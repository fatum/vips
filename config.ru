$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib/'))

require 'vips/app/server'

run Server
