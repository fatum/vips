require 'vips/dom/element'
require 'vips/dom/collection'

require 'vips/wraper/test'
require 'vips/wraper/watir'

module Vips
  class DriverCreator
    def self.create(driver)
      case driver
      when :watir
        Vips::Wraper::Watir.new(:firefox)
      when :test
        Vips::Wraper::Test.new
      end
    end
  end
end
