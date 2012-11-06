module Vips
  module Signal
    class Color
      def self.match?(el)
        el.children.find do |child|
          el.color != child.color ||
            el.background_color != child.background_color
        end != nil
      end
    end
  end
end
