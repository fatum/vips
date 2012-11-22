# -*- encoding : utf-8 -*-
require 'vips/dom/element'
require 'vips/block/element'
require 'vips/block/pool'

module Vips
  class Divider
    PDOC = 10
    ROUNDS = 1
    PAGE_SIZE = 1024 * 768

    attr_accessor :dom, :signals, :current_signal, :block_pool

    def self.divided
      @@divided
    end

    def initialize(signals)
      @signals, @@divided = signals, []
      @block_pool, @current_round = Vips::Block::Pool.new, 1
    end

    def divide!(dom)
      page_block = add_to_block_pool(dom)
      split(page_block)
    end

    # Executed at each round
    def split(block)
      puts "Divide block: #{block.inspect}"
      puts "Current round at #{@current_round}".red

      # 1. extract blocks
      block.el.children.each do |el|
        divide(el, 0, block)
      end

      # 2. find separators
      separators = find_separators(block)

      # 3. construct page
      construct_blocks(block, separators)

      @current_round += 1

      # После текущего раунда block.children содержит список
      # определившихся блоков. Если мы не прeвысили лимит раундов –
      # для каждого из них текущего уровня повторяем раунд split
      if ROUNDS >= @current_round
        block.children.each do |block|
          if block.leaf_node? && !granularity?
            split(block)
          end
        end
      end
      block
    end

    def find_separators(block)
      Separator::Manager.new.process(block.children)
    end

    def construct_blocks(block, separators)
    end

  private
    def signal_matched?(el, level)
      @current_signal = signals.find do |signal|
        log "checking #{signal.inspect}".blue, level
        signal.match?(el, level)
      end

      log "MATCHED! #{current_signal.inspect}".green, level if @current_signal
      @current_signal
    end

    def divide(el, level = 0, current_block = nil)
      log = ("-" * level) + "processing (#{level}): #{el.xpath}"

      debug el, level
      if signal_matched?(el, level)
        if current_signal.dividable == :dividable
          puts "divide!"
          @@divided << el
          puts log.red
          el.children.each { |child| divide(child, level + 1, current_block) }
        elsif current_signal.dividable == :undividable
          puts log.yellow
          block = add_to_block_pool(el, level, current_block)
          puts "create block! #{block}"
        end
      end
    end

    def add_to_block_pool(el, level = 0, current_block = nil)
      block = Block::Element.new(el, current_block)

      block.doc = current_signal.get_doc(el) if current_signal
      block.doc ||= Signal::Base::DEFAULT_DOC

      current_block.add_child(block) if current_block
      block
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
      log "text? - #{Signal::Color.text_node?(el)}", level
      log "valid? - #{Signal::Color.valid_node?(el)}", level
      log "inline? - #{Signal::Color.inline_node?(el)}", level
      log "has_valid_children? - #{Signal::Color.has_valid_children?(el)}", level

      log "width - #{el.width}", level
      log "height - #{el.height}", level
      log "visible - #{el.visible?}", level
    end
  end
end
