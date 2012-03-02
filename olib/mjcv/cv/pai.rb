require 'mjcv/geom/point'
require 'mjcv/geom/rect'
require 'mjcv/geom/point_op'
require 'mjcv/geom/rect_op'

module MjCV
  module CV
    class Pai
      include MjCV::Geom::PointOp
      include MjCV::Geom::RectOp
        def initialize(x=0, y=0, width=0, height=0, value=0, type=nil, direction=:top)
         @x = x
         @y = y
         @width = width
         @height = height
         @value = value
         @type = type
         @direction = direction
         @rect = MjCV::Geom::Rect.new(x, y, width, height)
        end
    
        attr_accessor :x, :y, :width, :height, :value, :type, :direction
  
        def position
          @rect.position
        end
        def to_str
          return "#{@type}t" if @direction == :top
          return "#{@type}r"
        end
    end
  end
end
