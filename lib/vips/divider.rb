# -*- encoding : utf-8 -*-
require 'vips/dom/element'
require 'vips/block/element'
require 'vips/pool'
require 'vips/signals'

module Vips
  class Divider
    PDOC = 5

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
    # Первый уровень блоков - потомки страницы (body)
    def divide_dom_into_blocks
      # 1. Добавляем body в visual block pool
      add_to_block_pool(dom)

      # 2. За первый раунд обходим всех потомков и определяем блоки
      dom.children.each do |child|
        add_to_block_pool(child)
      end

      # 3. Делаем 5 раундов или пока не находим PDoc > DoC
      max_round, current_round = 10, 0
      while max_round < current_round && !granularity?
        divide
        current_round += 1
      end
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

    def add_to_block_pool(el, parent = nil)
      block = Block::Element.new(el, parent)

      block.doc = current_signal.get_doc(el) if current_signal
      block.doc ||= Signal::Base::DEFAULT_DOC

      @block_pool << block
    end

    def granularity?
      @block_pool.find do |block|
        block.el.children.empty? || block.doc < PDOC
      end != nil
    end
  end
end
