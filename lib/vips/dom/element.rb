module Vips
  module Dom
    class Element
      attr_accessor :parent, :children, :attributes

      def initialize(attributes, parent = nil)
        @parent, @attributes = parent, attributes
        @children = Vips::Dom::Collection.new([])
      end

      def create_child(attributes)
        children << Element.new(attributes, self)
        children.last
      end

      def tag_name
      end

      def children
      end

      def parent
      end
    end

    class Selenium < Element
    end
  end
end
