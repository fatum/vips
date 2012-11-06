module Vips
  module Signal
    class Rule2
      extend Base

      def self.match?(el)
        if el.children.count == 1
          only_child = el.children.first
          ! virtual_text_node?(only_child)
        end
      end
    end
  end
end
