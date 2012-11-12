module Vips
  module Signal
    class Rule8
      extend Base

      def self.dividable
        :undividable
      end

      def self.match?(el, _)
        relative_size = get_relative_size(el, Divider::PAGE_SIZE)

        if relative_size < 0.1
          has_text_or_virtual_node?(el)
        end
      end
    end
  end
end
