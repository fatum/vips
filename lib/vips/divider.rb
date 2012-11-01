require 'vips/pool'
require 'vips/signals'

module Vips
  class Divider
    attr_accessor :dom, :signals

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
      dom.each { |el| divide(el) }
    end

    def signal_matched?(el)
      signals.select { |signal| signal.match?(el) }.any?
    end

    def divide(el)
      if signal_matched?(el)
        el.each { |child| divide(child) }
      else
        @block_pool << el
      end
    end
  end
end
