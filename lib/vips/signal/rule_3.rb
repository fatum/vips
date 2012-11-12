module Vips
  module Signal
    class Rule3
      extend Base

      def self.match?(el, level)
        level == 0
      end
    end
  end
end
