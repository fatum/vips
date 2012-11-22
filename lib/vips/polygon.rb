require 'geometry'

module Vips
  module Polygon
    def create_polygon
      Geometry::Polygon.new([
        Geometry::Point.new(left, top),
        Geometry::Point.new(full_width, top),
        Geometry::Point.new(full_width, full_height),
        Geometry::Point.new(left, full_height)
      ])
    end

    def contains?(polygon)
      polygon_intersect(polygon).size == 0
    end

    def cross?(polygon)
      polygon_intersect(polygon).size > 0
    end

    def have_same_vertices?(polygon)
      ! polygon.vertices.select { |point| create_polygon.find { |v| v == point } }.empty?
    end

  private
    def polygon_intersect(polygon)
      polygon.vertices.select { |point| !create_polygon.contains?(point) }
    end
  end
end
