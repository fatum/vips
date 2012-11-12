module Vips
  module Signal
    class Rule1
      extend Base

      def dividable
        :cut
      end

      def self.match?(el, level)
        return true unless valid_node?(el)

        ! text_node?(el) && ! has_valid_children?(el)
      end
    end
  end
end
