module Vips
  module Signal
    class Rule13
      extend Base

      def self.dividable
        :undividable
      end

      def self.doc
        doc = get_doc(el)
        doc += 3

        doc = 10 if doc > 10
        doc
      end

      def self.match?(el, _)
        are_children_small_node?(el)
      end
    end
  end
end
