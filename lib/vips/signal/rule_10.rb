module Vips
  module Signal
    class Rule10
      extend Base

      def self.match?(el, level)
        return unless el.parent

        parent_children = el.parent.children
        sibling = parent_children.first
        ! Divider.divided.include?(sibling)
      end
    end
  end
end
