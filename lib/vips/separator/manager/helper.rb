module Vips
  module HelperManager
    def split(sep, block)
      old_separator = sep.dup
      if sep.vertical?
        if cross_middle_of_separator_width?(sep, block)
          sep.width = sep.full_left - block.full_left
        else
          sep.left = block.full_left
        end
        create_separator(sep, width: block.left) unless cross?(sep, block)
      else
        # horizontal
        if cross_middle_of_separator_height?(sep, block)
          sep.height = sep.full_height - block.full_height
        else
          sep.top = block.full_height
        end
        create_separator(sep, height: block.top) unless cross?(sep, block)
      end
    end

    def cross_middle_of_separator_height?(sep, block)
      (sep.height / 2) + sep.top < block.top
    end

    def cross_middle_of_separator_width?(sep, block)
      (sep.width / 2) + sep.left < block.left
    end

    def create_separator(sep, attrs)
      attrs.merge! sep.attributes

      separators << Vips::Separator::Element.new(attrs)
    end

    def do_update_while_block_crossed_border(block, sep)
      if in_area?(block.left, block.top, sep)
        size1 = (block.top - sep.top) * sep.width
        size2 = sep.height * (block.left - sep.left)

        if size1 >= size2
          sep.height = block.top - sep.top
        else
          sep.width = block.left - sep.left
        end
      elsif in_area?(block.full_width, block.top, sep)
        size1 = (block.full_width - sep.top) * sep.width
        size2 = sep.height * (block.width - (block.full_width - sep.left))

        if size1 >= size2
          sep.height = block.top - sep.top
        else
          sep.width = block.width
          sep.left = block.full_width
        end
      elsif in_area?(block.left, block.full_height, sep)
        size1 = (sep.height - (block.full_height - sep.top)) * sep.width
        size2 = sep.height * (block.left - sep.top)

        if size1 >= size2
          sep.height = sep.height - (block.full_height - sep.top)
          sep.top = block.full_height
        else
          sep.width = block.left - sep.left
        end
      elsif in_area?(block.full_width, block.full_height, sep)
        size1 = (sep.height - (block.full_height - sep.top)) * sep.width
        size2 = sep.height * (block.width - (block.full_width - sep.left))

        if size1 >= size2
          sep.height = sep.height - (block.full_height - sep.top)
          sep.top = block.full_height
        else
          sep.width = block.width - (block.full_width - sep.left)
        end
      end
    end

    def separator_contains_block?(sep, block)
      contained?(sep, block)
    end

    def block_cover_separator?(block, sep)
      contained?(block, sep)
    end

    def block_cross_separator?(block, sep)
      cross?(sep, block)
    end

    def cross?(first, second)
      first.cross?(second.create_polygon)
    end

    def contained?(first, second)
      first.contains? second.create_polygon
    end

    def in_area?(x, y, block)
      if x > block.left && x < block.full_width
        y > block.top && y < block.full_height
      end
    end
  end
end
