require 'vips/dom/element'
require 'vips/pool'
require 'vips/signals'

module Vips
  class Divider
    attr_accessor :dom, :signals, :current_signal

    def initialize(dom, signals)
      @dom, @signals = dom, signals
      @block_pool = Vips::Pool.new
    end

    def get_result
      @result ||= divide_dom_into_blocks
      @block_pool
    end

  private
    def divide_dom_into_blocks
      divide(dom)
    end

    def signal_matched?(el)
      current_signal = signals.find { |signal| signal.match?(el) }
    end

    def divide(el, level = 1)
      puts ("-" * level) + "processing tag: #{el.xpath}"

      el.level = level

      if signal_matched?(el)
        el.children.each { |child| divide(child, level + 1) }
      else
        add_to_block_pool(el)
      end
    end

    def add_to_block_pool(el)
      el.doc = current_signal.get_doc(el) if current_signal
      @block_pool << el
    end
  end
end
