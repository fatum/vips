require "vips/version"
require 'vips/divider'

module Vips
  class Extractor
    SIGNALS = [
      Signal::Color, Signal::Rule1, Signal::Rule2
    ]

    def self.extract_blocks_from_dom(dom)
      pool = Divider.new(dom, SIGNALS).get_result

      if pool.any?
        separators = find_separators(dom)
        build_final_blocks(pool, separators)
      else
        puts "No one blocks extracted"
        []
      end
    end

    def self.find_separators(dom)
    end

    def self.build_final_blocks(pool, separators)
      pool.dup
    end
  end
end
