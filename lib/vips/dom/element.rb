module Vips
  module Dom
    class Element
      attr_reader :children, :attributes
      attr_accessor :parent

      def initialize(attributes, parent = nil)
        @parent, @attributes = parent, attributes
        @children = []

        %w(width height).each { |el| attributes[el.to_sym] ||= 0 }
      end

      def create_child(attributes)
        children << Element.new(attributes, self)
        children.last
      end

      def remove_children!
        @children = []
      end

      def add_child(child)
        child.parent ||= self
        children << child
      end

      def text_node?
        text != nil && text.length > 0 && children.empty?
      end

      %w(
        tag_name xpath
        color background_color
        width height
        text visible?
        offset_left offset_top
      ).each do |attr|
        define_method(attr.to_sym) { attributes[attr.to_sym] }
      end
    end
  end
end
