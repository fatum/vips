module Vips
  module Signal
    class Color
      extend Signal::Base

      def self.match?(el, level)
        el.children.find do |child|
          el.color != child.color ||
            el.background_color != child.background_color
        end != nil
      end
    end
  end
end
