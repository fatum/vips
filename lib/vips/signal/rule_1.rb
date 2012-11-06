module Vips
  module Signal
    class Rule1
      extend Base

      def self.match?(el)
        return true unless valid_node?(el)

        ! text_node?(el) && ! has_valid_children?(el)
      end
    end
  end
end
