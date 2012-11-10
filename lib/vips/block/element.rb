module Vips
  module Block
    class Element
      attr_reader :el
      attr_accessor :doc, :level, :parent

      def initialize(el, parent = nil)
        @doc, @level, @parent, @el = 8, 0, parent, el
      end
    end
  end
end
