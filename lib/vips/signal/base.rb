module Vips
  module Signal
    module Base
      DEFAULT_DOC = 8
      DEFAULT_PAGE_SIZE = 1024 * 768

      def doc
        :dividable
      end

      def get_doc(el)
        if [:dividable, :cut].include?(doc)
          return 0
        else
          get_calculated_doc(el, el.level)
        end
      end

      def get_calculated_doc(el)
        doc = 0
        size = get_size(el)
        relative_size = size / DEFAULT_PAGE_SIZE
        return 1 if relative_size >= 1

        doc = (1 - relative_size) * 10
        has_small_children = are_children_small_node?(el)

        doc += 2 if has_small_children
        doc -= 1 if has_line_break_child?(el)

        doc
      end

      def get_size(el)
        size = el.width * el.height
        sum_of_children = el.children.inject(0) do |sum, child|
          sum += child.width * child.height
        end
        size > sum_of_children ? size : sum_of_children
      end

      # All children is small?
      def are_children_small_node?(el)
        false if el.empty?

        not_small_child = el.children.find { |child| !small_node?(child) }
        not_small_child ? false : true
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

      def small_node?(el)
        el.width <= 500 && el.height <= 40
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
