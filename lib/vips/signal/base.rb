module Vips
  module Signal
    module Base
      DEFAULT_DOC = 2
      DEFAULT_PAGE_SIZE = 1024 * 768

      def dividable
        :dividable
      end

      def doc
        nil
      end

      def get_doc(el)
        return doc if doc

        if [:dividable, :cut].include?(dividable)
          return 0
        else
          get_calculated_doc(el)
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

      def get_relative_size(el, page_size)
        get_size(el).to_f / page_size.to_f
      end

      # All children is small?
      def are_children_small_node?(el)
        return false if el.children.empty?

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
        el.text_node?
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

      def child_node_hr_tag?(el)
        el.children.find { |child| !text_node?(child) && child.tag_name.downcase == "hr" } != nil
      end

      def has_valid_children?(el)
        el.children.find { |child| valid_node?(child) } != nil
      end

      def has_line_break_child?(el)
        el.children.find { |child| !inline_node?(child) } != nil
      end

      def has_text_or_virtual_node?(el)
        el.children.find { |child| text_node?(child) || inline_node?(child) } != nil
      end

      def children_not_virtual_node?(el)
        el.children.find { |child| ! virtual_text_node?(child) } != nil
      end

      def children_virtual_text_node?(el)
        el.children.find { |child| !virtual_text_node?(child) } == nil
      end
    end
  end
end
