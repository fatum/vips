module Vips
  module Dom
    class Collection < Array
      def initialize(elements)
        elements.each { |el| self << el }
      end
    end

    class WatirCollection < Array
      def initialize(watir_collection)
      end
    end
  end
end
