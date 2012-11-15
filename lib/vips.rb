require "vips/version"
require 'vips/divider'
require 'vips/separator/manager'
require 'colored'

module Vips
  class Segmenter
    def extract_blocks
    end

    def extract_separators
    end

    def construct_page
    end
  end

  class Extractor
    SIGNALS = [
      Signal::Rule1,
      Signal::Rule2,
      Signal::Rule3,
      Signal::Rule4,
      Signal::Rule5,
      Signal::Rule6,
      Signal::Color,
      Signal::Rule8,
      Signal::Rule10,
      Signal::Rule13
    ]

    def self.prepare_bookmark_data(input)
      node = Hash.new
      input.keys.each { |k| node[k.to_sym] = input[k] }
      children = node[:children]
      if children && children.any?
        node[:children] = children.map { |child| prepare_bookmark_data(child) }
      end
      node[:tag_name].downcase!

      %w(width height offset_left offset_top).each do |k|
        node[k.to_sym] = node[k.to_sym].to_i
      end

      node[:visible?] = node[:visible] == "true"
      node
    end

    def self.build_dom_elements(data)
      children = data.delete(:children)
      node = Dom::Element.new(data)

      children.each { |child| node.add_child(build_dom_elements(child)) } if children
      node
    end

    def self.extract_blocks_from_dom(dom)
      pool = Divider.new(dom, SIGNALS).get_result

      if pool.any?
        separators = find_separators(pool)
        construct_page(pool, separators)
      else
        puts "No one blocks extracted"
        []
      end
    end

    def self.find_separators(pool)
      manager = Separator::Manager.new
      manager.process(pool)
    end

    def self.construct_page(pool, separators)
      pool.dup
    end
  end
end
