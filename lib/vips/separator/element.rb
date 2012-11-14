module Vips
  module Separator
    class Element
      attr_accessor :blocks, :children, :attributes

      def initialize(attributes = {})
        @children, @attributes = [], attributes
      end

      %w(width height left top).each do |el|
        define_method(el.to_sym) { attributes[el.to_sym] }
        define_method(:"#{el}=") { |v| attributes[el.to_sym] = v }
      end

      def full_width
        left + width
      end

      def full_height
        top + height
      end

      def vertical?
        height > width
      end

      def weight
        height * width
      end
    end
  end
end
