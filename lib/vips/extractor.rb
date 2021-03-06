require 'vips/polygon'
require 'vips/adjacent'

require 'vips/separator/manager'
require 'vips/signals'
require 'vips/divider'
require 'colored'

module Vips
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

    attr_reader :dom, :elements,
                :blocks, :separators,
                :constructed_blocks

    def initialize(dom)
      @dom = prepare_dom_data(dom)
      @elements = build_elements(@dom)
    end

    def extract_blocks!
      @blocks ||= split_elements_to_blocks
    end

  private
    def prepare_dom_data(input)
      node = Hash.new
      input.keys.each { |k| node[k.to_sym] = input[k] }
      children = node[:children]
      if children && children.any?
        node[:children] = children.map { |child| prepare_dom_data(child) }
      end
      node[:tag_name].downcase!

      %w(width height offset_left offset_top).each do |k|
        node[k.to_sym] = node[k.to_sym].to_i
      end

      node[:visible?] = node[:visible] == "true"
      node
    end

    def build_elements(data)
      children = data.delete(:children)
      node = Dom::Element.new(data)

      children.each do |child|
        node.add_child(build_elements(child))
      end if children
      node
    end

    def split_elements_to_blocks
      Divider.new(SIGNALS).divide!(elements)
    end
  end
end
