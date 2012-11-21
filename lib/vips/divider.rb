# -*- encoding : utf-8 -*-
require 'vips/dom/element'
require 'vips/block/element'
require 'vips/block/pool'

module Vips
  class Divider
    PDOC = 10
    ROUNDS = 1
    PAGE_SIZE = 1024 * 768

    attr_accessor :dom, :signals, :current_signal

    def self.divided
      @@divided
    end

    def initialize(dom, signals)
      @dom, @signals, @@divided = dom, signals, []
      @block_pool = Vips::Block::Pool.new
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

      # 2. Весь первый уровень - блоки
      dom.children.each do |child|
        add_to_block_pool(child)
      end

      # 3. Делаем 5 раундов или пока не находим PDoc > DoC
      current_round = 0
      while ROUNDS > current_round && !granularity?
        puts "Round at #{current_round}".blue
        current_round += 1

        @block_pool.each do |block|
          if block.leaf_node? && !granularity?
            log "Granularity: #{block.doc}".blue, block.level
            divide(block.el, 0)
          end
        end
      end
    end

    def signal_matched?(el, level)
      @current_signal = signals.find do |signal|
        log "checking #{signal.inspect}".blue, level
        signal.match?(el, level)
      end

      log "MATCHED! #{current_signal.inspect}".green, level if @current_signal
      @current_signal
    end

    def divide(el, level = 0, ancessor = nil)
      log = ("-" * level) + "processing (#{level}): #{el.xpath}"

      debug el, level
      if signal_matched?(el, level)
        if current_signal.dividable == :dividable
          @@divided << el
          puts log.red
          el.children.each { |child| divide(child, level + 1, @block_pool.last) }
        elsif current_signal.dividable == :undividable
          puts log.yellow
          add_to_block_pool(el, level, ancessor)
        end
      end
    end

    def add_to_block_pool(el, level = 0, parent = nil)
      block = Block::Element.new(el, parent)

      block.doc = current_signal.get_doc(el) if current_signal
      block.doc ||= Signal::Base::DEFAULT_DOC

      @block_pool << block
    end

    def granularity?
      @block_pool.find do |block|
        block.leaf_node? && block.doc >= PDOC
      end != nil
    end

    def log(msg, level)
      puts (" " * (level + 1)) + msg
    end

    def debug(el, level)
      log "text - #{Signal::Color.text_node?(el)}", level
      log "width - #{el.width}", level
      log "height - #{el.height}", level
      log "visible - #{el.visible?}", level
    end
  end
end
