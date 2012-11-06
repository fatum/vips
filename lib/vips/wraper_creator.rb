require 'vips/dom/element'
require 'vips/dom/collection'

require 'vips/wraper/test'
require 'vips/wraper/watir'

module Vips
  class WraperCreator
    def self.create(wraper)
      case wraper
      when :watir
        Vips::Wraper::Watir.new(:firefox)
      when :nokogiri
        Vips::Wraper::Nokogiri.new
      when :test
        Vips::Wraper::Test.new
      end
    end
  end
end
