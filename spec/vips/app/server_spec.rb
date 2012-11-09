require 'rack/test'
require 'vips/app/server'
require 'spec_helper'

describe "Server" do
  include Rack::Test::Methods

  def app
    Server.new
  end

  it "should respond to /" do
    post '/extract'
    last_response.should be_ok
  end
end
