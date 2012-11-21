require 'vips/separator/element'
require 'vips/separator/manager/helper'

module Vips
  module Separator
    class Manager
      include HelperManager

      attr_accessor :separators, :page

      def initialize
        @page = Element.new
        @page.width = @page.height = @page.left = @page.top = 0

        @separators = [@page]
      end

      def process(pool)
        initialize_separators(pool)
        remove_separator_which_adjacent_border
        #expand_and_refine_separator(pool)
        set_relative_blocks(pool)
        remove_separators_without_relative_blocks!

        separators
      end

      def init_page(block)
        if block.width > page.width
          page.width = block.width
        end

        if block.height > page.height
          page.height = block.height
        end
      end

      def evaluate_block(block)
        return if block.text_node?

        puts "Evaluate block: #{block.el.xpath}".green
        separators.each do |sep|
          if separator_same_with_block?(sep, block)
            separators.delete(sep)
          elsif separator_contains_block?(sep, block)
            #If the block is contained in the separator, split the separator.
            puts "Separator contain block"
            split(sep, block, while_contained = true)
          elsif block_cover_separator?(block, sep)
            #If the block covers the separator, remove the separator.
            puts "Block cover separator"
            separators.delete(sep)
          elsif block_cross_separator?(block, sep)
            puts "Block across separator"
            split(sep, block)
          else
            #If the block crosses with the separator, update the separator's parameters.
            puts "UpdateWhileBlockCrossedBorder"
            #do_update_while_block_crossed_border(block, sep)
          end
        end
      end

      def initialize_separators(pool)
        # Set page size
        pool.each { |block| init_page(block) }

        # split separators
        pool.each do |block|
          if block.leaf_node?
            evaluate_block(block)
          end
        end
      end

      def remove_separators_without_relative_blocks!
        puts "Remove separators without relative blocks".blue
        separators.each { |s| separators.delete(s) if s.blocks.size == 0 }
      end

      def remove_separator_which_adjacent_border
        puts "Remove separator which adjacent border".blue
        separators.each do |sep|
          if sep.left == 0 && sep.height > sep.height ||
            sep.top == 0 && sep.width > sep.height

            separators.delete(sep)
          elsif sep.full_width == page.width && sep.height > sep.width ||
            sep.full_height == page.height && sep.width > sep.height

            separators.delete(sep)
          end
        end
      end

      def set_relative_blocks(blocks)
        puts "Set relative blocks".blue
        separators.each do |sep|
          sep.blocks = sep.find_adjacent_blocks(blocks)
        end
      end

      def expand_and_refine_separator(blocks)
        puts "Expand and refine separator".blue
        expand_separator
        refine_separator(blocks)
        remove_separator_which_ajacent_border
      end

      def refine_separator(blocks)
        blocks.each { |block| evaluate_block(block) }
      end

      def expand_separator
        separators.each do |separator|
          if separator.vertical?
            separator.height = page.height
          else
            separator.width = page.width
          end
        end
      end
    end
  end
end
