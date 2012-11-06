require "vips/version"
require 'vips/divider'
require 'vips/wraper_creator'

module Vips
  def self.get_driver(type)
    @@driver ||= {}
    @@driver[type] ||= WraperCreator.create(type)
  end

  def self.quit(type)
    @@driver[type].quit if @@driver[type]
  end
end
