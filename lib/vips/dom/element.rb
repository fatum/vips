module Vips
  module Dom
    class Element
      attr_reader :parent, :children, :attributes

      def initialize(attributes, parent = nil)
        @parent, @attributes = parent, attributes
        @children = Vips::Dom::Collection.new([])
      end

      def create_child(attributes)
        children << Element.new(attributes, self)
        children.last
      end

      %w(
        tag_name parent color background_color width height text visible?
      ).each do |attr|
        define_method(attr.to_sym) { attributes[attr.to_sym] }
      end
    end
  end
end
