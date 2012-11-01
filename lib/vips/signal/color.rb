module Vips
  module Signal
    class Color
      def self.match?(el)
        el.color != el.parent.color
      end
    end
  end
end
