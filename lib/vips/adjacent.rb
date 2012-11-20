module Vips
  module Adjacent
    def find_adjacent_blocks(blocks)
      blocks.select { |block| adjacent_block?(block) }
    end

    def adjacent_block?(block)
      if block.vertical? && vertical?
        adjacent_vertical?(block)
      elsif ! block.vertical? && !vertical?
        adjacent_horizontal?(block)
      elsif block.vertical? && !vertical?
        adjacent_horizontal?(block, check_distance=true)
      end
    end

    def adjacent_vertical?(block)
      if top <= block.top && block.full_width <= full_width
        d = block.left - left
        if d >= 0 && d < 5
          return true
        else
          d = left - block.full_width
          d >= 0 && d < 5
        end
      end
    end

    def adjacent_horizontal?(block, check_distance = false)
      if left <= block.left && block.full_width <= full_width
        d = block.top - top
        if d >= 0 && d < 5
          true
        else
          d = block.top - full_height
          if d >= 0 && d < 5
            true
          #else d < get_horizontal_distance(block)

          end
        end
      end
    end

    def get_horizontal_distance(block)
      if left <= block.left && block.full_width <= full_width
        d = block.top - top
        if d >= 0 && d < 5
          return d
        else
          d = block.top - full_height
          return d if d >= 0 && d < 5
        end
      end
      100000
    end

  end
end
