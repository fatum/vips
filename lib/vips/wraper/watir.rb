require 'headless'
require 'watir'

module Vips
  module Wraper
    class Watir
      attr_reader :driver

      def initialize(type)
        @driver = ::Watir::Browser.new(type)
      end

      def goto(url)
        @driver.goto(url)
        @driver.elements.map { |el| Vips::Dom::WatirCollection.new(el) }
      end

      def quit
        @driver.quit if @driver
      end
    end
  end
end
