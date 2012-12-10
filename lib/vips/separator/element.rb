module Vips
  module Separator
    class Element
      include Polygon
      include Adjacent

      attr_accessor :blocks, :attributes

      def initialize(attributes = {})
        @blocks, @attributes = [], attributes
      end

      %w(width height left top).each do |el|
        define_method(el.to_sym) { attributes[el.to_sym] }
        define_method(:"#{el}=") { |v| attributes[el.to_sym] = v }
      end

      def coordinates
        {
          width: width, height: height,
          left: full_width, top: full_height
        }
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
