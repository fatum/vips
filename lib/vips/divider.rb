# -*- encoding : utf-8 -*-
require 'vips/dom/element'
require 'vips/block/element'
require 'vips/block/pool'

module Vips
  class Divider
    PDOC = 10
    ROUNDS = 3
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
      level = create_empty_level

      add_to_level(dom, level)

      split_level(level)
    end

    # Executed at each round
    def split_level(level, level_list = [])
      level_list << level

      next_level = create_empty_level

      puts "Current round at #{@current_round}".red
      puts "Current level have #{level.blocks.size} blocks".red

      level.blocks.size.times do |i|
        block = level.blocks[i]

        puts "Divide block: #{block}"
        if block.leaf_node? && !granularity?
          puts 'Split level'
          split(block, next_level)
        end
      end

      # 2. find separators
      level.separators = find_separators(level)

      # 3. construct page
      #construct_blocks(block)

      @current_round += 1

      # После текущего раунда block.children содержит список
      # определившихся блоков. Если мы не прeвысили лимит раундов –
      # для каждого из них текущего уровня повторяем раунд split
      if ROUNDS >= @current_round
        split_level(next_level, level_list)
      end

      level_list
    end

    def split(block, level)
      # 1. extract blocks
      block.el.children.each do |el|
        #puts "Divide children #{el}"
        divide(el, 0, level)
      end
    end

    def find_separators(level)
      Separator::Manager.new.process(level.blocks)
    end

    def construct_blocks(block)
    end

  private
    def create_empty_level
      OpenStruct.new(blocks: [], separators: [])
    end

    def signal_matched?(el, level)
      @current_signal = signals.find do |signal|
        log "checking #{signal.inspect}".blue, level
        signal.match?(el, level)
      end

      log "MATCHED! #{current_signal.inspect}".green, level if @current_signal
      @current_signal
    end

    def divide(el, level = 0, block_level = nil)
      log = ("-" * level) + "processing (#{level}): #{el.xpath}"

      debug el, level
      if signal_matched?(el, level)
        if current_signal.dividable == :dividable
          #puts "divide!"
          @@divided << el
          #puts log.red
          el.children.each { |child| divide(child, level + 1, block_level) }
        elsif current_signal.dividable == :undividable
          #puts log.yellow
          block = add_to_level(el, block_level)
          #puts "create block! #{block}"
        end
      end
    end

    def add_to_level(el, level = nil)
      block = Block::Element.new(el)

      block.doc = current_signal.get_doc(el) if current_signal
      block.doc ||= Signal::Base::DEFAULT_DOC

      level.blocks << block if level
      block
    end

    def granularity?
      @block_pool.find do |block|
        block.leaf_node? && block.doc >= PDOC
      end != nil
    end

    def log(msg, level)
      return
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
