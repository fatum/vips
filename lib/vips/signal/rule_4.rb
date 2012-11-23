module Vips
  module Signal
    class Rule4
      extend Base

      def self.dividable
        :undividable
      end

      def self.doc
        9
      end

      def self.match?(el, level)
        # TODO: check font-size and font-weight
        ! virtual_text_node?(el)
      end
    end
  end
end
