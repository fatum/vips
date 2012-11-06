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
        driver.goto(url)
        Vips::Dom::WatirElement.new driver.element(xpath: '/html/body')
      end

      def quit
        @driver.quit if @driver
      end
    end
  end
end
