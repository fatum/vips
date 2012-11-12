module Vips
  module Signal
   class Rule6
     extend Base

     def self.match?(el, _)
       child_node_hr_tag?(el)
     end
   end
  end
end
