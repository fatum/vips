require 'thor'
require 'vips'

require 'em-http'
require 'faye/websocket'
require 'json'

module Vips
  class Thor < ::Thor
    desc 'test', "Set url for block's extraction"
    def test
      EM.run do
        # Chrome runs an HTTP handler listing available tabs
        conn = EM::HttpRequest.new('http://localhost:9222/json').get
        conn.callback do
          resp = JSON.parse(conn.response)
          puts "#{resp.size} available tabs, Chrome response: \n#{resp}"

          # connect to first tab via the WS debug URL
          ws = Faye::WebSocket::Client.new(resp.first['webSocketDebuggerUrl'])
          ws.onopen = lambda do |event|
            # tell Chrome to navigate to twitter.com and look for "chrome" tweets
            ws.send JSON.dump({
              id: 2,
              method: 'Page.navigate',
              params: {url: 'http://lenta.ru/?' + rand(100).to_s}
            })

            retrive_document!
            ws.send JSON.dump(
              id: 2,
              method: "DOM.getAttributes",
              params: { nodeId: 5 }
            )

            #ws.send JSON.dump({
              #id: 2,
              #method: 'DOM.highlightRect',
              #params: {
                #x: 100, y: 100,
                #width: 100, height: 100,
                #color: {r: 0, b: 0, g: 0}
              #}
            #})
          end

          ws.onmessage = lambda do |event|
            binding.pry
            # print event notifications from Chrome to the console
            p [:new_message, JSON.parse(event.data)]
          end
        end
      end
    end
  end
end
