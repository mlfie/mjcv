require 'test_helper'

class RectOpTest < Test::Unit::TestCase
  class Rect
    include MjCV::Geom::RectOp
    attr_accessor :position, :width, :height
    def initialize(position,width,height)
      @position=position
      @width=width
      @height=height
    end
  end

  def setup
    @r0 = Rect.new(MjCV::Geom::Point.new(3,3), 4, 4)
    @r1 = Rect.new(MjCV::Geom::Point.new(5,5), 6, 6)
    @r2 = Rect.new(MjCV::Geom::Point.new(8,8), 6, 6)
  end

  def test_intersect
    assert @r0.intersect?(@r1)
    assert_equal 4, @r0.intersect_area(@r1)
    assert_equal 4, @r1.intersect_area(@r0)

    assert !@r0.intersect?(@r2)
    assert_equal 0, @r0.intersect_area(@r2)
    assert_equal 0, @r2.intersect_area(@r0)
  end

end
