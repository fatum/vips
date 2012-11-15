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

    def separator_contain_block?(block, sep)
      contained?(block, sep)
    end

    def block_cover_separator?(block, sep)
      contained?(sep, block)
    end

    def block_across_separator?(block, sep)
      across?(sep, block)
    end

    def across?(sep, block)
      higher, lower = sep, block

      if block.width >= sep.height
        higher = block
        lower = sep
      end

      if width_locate_between(higher, lower.left, lower.full_width)
        height_locate_between(lower, higher.top, higher.full_height)
      end
    end

    def width_locate_between(block, l, r)
      left, right = l, r
      left, right = r, l if left > right

      block.left > left && block.full_width < right
    end

    def height_locate_between(block, t, b)
      top, bottom = t, b
      top, bottom = b, t if top > bottom

      block.top > top && block.full_height < bottom
    end

    def contained?(sep, block)
      separator_offset?(sep, block) && separator_smaller?(sep, block)
    end

    def separator_smaller?(sep, block)
      sep.full_width <= block.full_width && sep.full_height <= block.full_width
    end

    def separator_offset?(sep, block)
      block.left <= sep.left && block.top <= sep.top
    end

    def in_area?(x, y, block)
      if x > block.left && x < block.full_width
        y > block.top && y < block.full_height
      end
    end

    def ajacent_vertical?(block, sep)
      if sep.top <= block.top && block.full_width <= sep.full_width
        d = block.left - sep.left
        if d >= 0 && d < 5
          return true
        else
          d = sep.left - block.full_width
          d >= 0 && d < 5
        end
      end
    end

    def ajacent_horizontal?(block, sep)
      if sep.left <= block.left && block.full_width <= sep.full_width
        d = block.top - sep.top
        if d >= 0 && d < 5
          true
        else
          d = block.top - sep.full_height
          d >= 0 && d < 5
        end
      end
    end

    def get_horizontal_distance(block, sep)
      if sep.left <= block.left && block.full_width <= sep.full_width
        d = block.top - sep.top
        if d >= 0 && d < 5
          return d
        else
          d = block.top - sep.full_height
          return d if d >= 0 && d < 5
        end
      end
      100000
    end
  end
end
