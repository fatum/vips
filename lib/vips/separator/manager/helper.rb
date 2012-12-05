# -*- encoding : utf-8 -*-
module Vips
  module HelperManager
    def split(sep, block)
      puts '----------- Try split separator by block..'
      puts "Separator: #{sep.attributes.inspect}"
      puts "Block: #{block.attributes.inspect}"

      old_top = sep.top
      old_width = sep.width
      old_left = sep.left
      old_full_width = sep.full_width

      if sep.vertical?
        puts 'Separator is vertical'

        puts 'Сдвигаем сепаратор до правой границы блока'
        sep.width = block.left

        puts 'Если блок находится внутри сепаратора, то создаём новый блок'
        if old_left < block.left
          create_separator(sep, left: block.full_width, width: (old_full_width - block.full_width).abs)
        end
      #else
        #puts 'Separator is horizontal'

        #puts 'Опускаем сепаратор до нижней границы блока'
        #sep.top = block.full_height

        #puts 'Если блок находится внутри сепаратора, то создаём новый блок'
        #if old_top < block.top
          #create_separator(sep, top: old_top, height: block.top)
        #end
      end

      #binding.pry; abort
    end

    def same?(sep, block)
      sep.width == block.width &&
        sep.height == block.height &&
        sep.left == block.left &&
        sep.top == block.top
    end

    def cross_middle_of_separator_height?(sep, block)
      (sep.height / 2) + sep.top < block.top
    end

    def cross_middle_of_separator_width?(sep, block)
      (sep.width / 2) + sep.left < block.left
    end

    def create_separator(sep, attrs)
      attributes = sep.attributes.dup
      attributes.merge! attrs

      new_sep = Vips::Separator::Element.new(attributes)
      if !same?(sep, new_sep) && !separators.find { |s| same?(s, new_sep) }
        separators << new_sep
      end
    end

    def separator_contains_block?(sep, block)
      contained?(sep, block)
    end

    def block_cover_separator?(block, sep)
      contained?(block, sep) && !sep.have_same_vertices?(block.create_polygon)
    end

    def block_cross_separator?(block, sep)
      cross?(sep, block) && !sep.have_same_vertices?(block.create_polygon)
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
