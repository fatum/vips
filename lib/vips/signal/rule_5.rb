module Vips
  module Signal
    class Rule5
      extend Base

      def self.match?(el, level)
        has_line_break_child?(el)
      end
    end
  end
end
