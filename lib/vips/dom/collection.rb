module Vips
  module Dom
    class Collection < Array
      def initialize(elements)
        elements.each { |el| self << el }
      end
    end
  end
end
