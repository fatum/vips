module Vips
  module Block
    class Element
      include Polygon

      attr_reader :el, :children
      attr_accessor :doc, :level, :parent

      def initialize(el, parent = nil)
        el = el.dup

        @children, @doc, @level, @parent, @el = [], 8, 0, parent, el
      end

      %w(width height).each do |action|
        define_method(action) { el.send action }
      end

      def add_child(child)
        child.parent ||= self
        children << child
      end

      def vertical?
        height > width
      end

      def leaf_node?
        children.empty?
      end

      def text_node?
        el.text_node?
      end

      def left
        el.offset_left
      end

      def top
        el.offset_top
      end

      def full_width
        el.offset_left + el.width
      end

      def full_height
        el.offset_top + el.height
      end

      def xpath
        el.xpath
      end
    end
  end
end
