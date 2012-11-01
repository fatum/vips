require "vips/version"
require 'vips/divider'
require 'vips/driver_creator'

module Vips
  def self.get_driver(type)
    @@driver ||= DriverCreator.create(type)
  end

  def self.quit
    @@driver.quit if @@driver
  end
end
