module Vips
  module Dom
    class Element
      attr_reader :children, :attributes
      attr_accessor :parent

      def initialize(attributes, parent = nil)
        @parent, @attributes = parent, attributes
        @children = []
      end

      def create_child(attributes)
        children << Element.new(attributes, self)
        children.last
      end

      def add_child(child)
        child.parent ||= self
        children << child
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
