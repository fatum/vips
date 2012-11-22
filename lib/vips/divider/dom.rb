module Vips
  class Divider
   class Dom
    ROUNDS = 1
      attr_reader :block, :level, :blocks, :signal

      def initialize(block, level = 0)
        @block, @level, @blocks = block, level, []
      end

      def divide!(signals)
        @current_round = 0
      end

      def divide(root, signals)
        @current_round += 1

        log "Process block #{block.inspect}"
        @signal = match_signals(signals)

        log "Match signal: #{@signal.inspect}".green
        if @signal && @signal.dividable == :dividable
          @level += 1
          root.el.children.each do |child|
            divide(child, root)
          end
        elsif !@signal || @signal.dividable == :undividable
          create_block_from_element!(block, root)
        end
        @blocks
      end

      def create_block_from_element!(element, root)
        if element != root
          block = Block::Element.new(element, root)
        else
          block = root
        end

        block.doc = @signal.get_doc(el) if @signal
        block.doc ||= Signal::Base::DEFAULT_DOC

        @blocks << block
      end

      def match_signals(signals)
        signals.find do |signal|
          log "checking #{signal.inspect}".blue
          signal.match?(@block.el, @level)
        end
      end

      def round?
        ROUNDS < current_round
      end

      def granularity?
        @blocks.find do |block|
          block.leaf_node? && block.doc >= PDOC
        end != nil
      end

      def log(msg)
        puts (" " * (@level + 1)) + msg
      end

      def debug(el)
        log "text - #{Signal::Color.text_node?(el)}"
        log "width - #{el.width}"
        log "height - #{el.height}"
        log "visible - #{el.visible?}"
      end
    end
  end
end
