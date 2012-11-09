module Vips
  module Signal
    module Base
      def get_doc(el)
        if [:dividable, :cut].include?(doc)
          return 0
        else
          get_calculated_doc(el, el.level)
        end
      end

      def get_calculated_doc(el, level)
        size = el.width * el.height
        sum_of_children = el.children.inject(0) do |sum, child|
          sum += child.width * child.height
        end
        size > sum_of_children ? size : sum_of_children
      end

      def valid_node?(el)
        return el.visible? if text_node?(el)

        el.width !=nil &&
          el.height != nil &&
          el.width != 0 &&
          el.height != 0
      end

      def text_node?(el)
        el.text != nil && el.text.length > 0 && el.children.empty?
      end

      def virtual_text_node?(el)
        if !inline_node?(el) && ! text_node?(el)
          return false
        end

        if el.children.any?
          children_not_virtual_node?(el)
        else
          text_node?(el)
        end
      end

      def inline_node?(el)
        %w(b big em font i strong u).include?(el.tag_name.to_s)
      end

      def has_valid_children?(el)
        el.children.find { |child| valid_node?(child) } != nil
      end

      def children_not_virtual_node?(el)
        el.children.find { |child| ! virtual_text_node?(child) } != nil
      end
    end
  end
end
