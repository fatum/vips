module Vips
  module HelperManager
    def split(sep, block, while_contained = false)
      condition = while_contained ?
        (block.height > block.width) :
        sep.left < block.left

      if block.width == 0 || block.height == 0
        puts "block width null size".red
        return
      end

      if condition
        # split vertical
        height = sep.height
        width = sep.width - block.width - (block.left - sep.left)
        left = block.left + block.width
        top = sep.top

        new_sep = Vips::Separator::Element.new(
          width: width, height: height,
          left: left, top: top
        )
        separators << new_sep
        sep.width = block.left - sep.left
        new_sep
      else
        # split horizontal
        height = sep.height - block.height - (block.top - sep.top)
        width = sep.width
        left = sep.left
        top = block.top + block.height

        new_sep = Vips::Separator::Element.new(
          width: width, height: height,
          left: left, top: top
        )
        separators << new_sep
        sep.height = block.top - sep.top
        new_sep
      end
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

    def separator_same_with_block?(sep, block)
      sep.width == block.width &&
        sep.height == block.height &&
        sep.left == block.left &&
        sep.top == block.top
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
