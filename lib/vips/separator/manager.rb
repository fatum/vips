require 'vips/separator/element'
require 'vips/separator/manager/helper'

module Vips
  module Separator
    class Manager < Array
      include HelperManager

      attr_reader :page

      def initialize
        @page = Element.new
        @page.width = @page.height = 0

        self << @page
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
        return if block.el.text_node?

        self.each do |sep|
          if separator_contain_block?(block, sep)
            #If the block is contained in the separator, split the separator.
            puts "Separator contain block"
            split(sep, block, while_contained = true)
          elsif block_cover_separator?(block, sep)
            #If the block covers the separator, remove the separator.
            puts "Block cover separator"
            self.delete(sep)
          elsif block_across_separator?(block, sep)
            puts "Block across separator"
            split(sep, block)
          else
            #If the block crosses with the separator, update the separator's parameters.
            puts "UpdateWhileBlockCrossedBorder"
            do_update_while_block_crossed_border(block, sep)
          end
        end
      end

      def expand_separator
        self.each do |separator|
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
