module Vips
  module Block
    class Element
      attr_reader :el, :children
      attr_accessor :doc, :level, :parent

      def initialize(el, parent = nil)
        @children, @doc, @level, @parent, @el = [], 8, 0, parent, el
      end

      def add_child(child)
        child.parent ||= self
        children << child
      end

      def leaf_node?
        children.empty?
      end
    end
  end
end
