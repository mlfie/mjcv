require 'test/unit'
require 'test_helper'
require 'mjcv/fitting/least_median_squares_line_fitting'
require 'mjcv/fitting/line_fitting'
require 'mjcv/cv/template_matching_analyzer'
require 'mjcv/cv/template_matching'
require 'mjcv/cv/filter'
require 'mjcv/cv/selector'
require 'mjcv/cv/pai'
require 'rubygems'
require 'opencv'
require 'cv_test_helper'

include OpenCV
class TemplateMatcherTest < Test::Unit::TestCase
  include CvTestHelper
  include MjCV::CV
  include MjCV::CV::TemplateMatching

  def setup
    @path = File.expand_path('../../../../../olib/mjcv/cv/base', __FILE__)
    @test_path = File.expand_path('../test_img', __FILE__)
    @matcher = TemplateMatcher.new(
      :type => PaiEnum.type_e::J7,
      :image_paths => ["#{@path}/j7.t.jpg"],
      :symmetric => false
    )

    #for debug mode, uncomment below
    #$__debug_window ||= GUI::Window.new "TemplateMatcher DEBUG"
    #@matcher.instance_eval { @debug = true }
  end

  def test_attributes
    assert_equal PaiEnum.type_e::J7, @matcher.type
    assert_equal :top, @matcher.direction
    assert_equal false, @matcher.symmetric?
  end

  def test_detect
    pais = @matcher.detect(CvMat.load("#{@test_path}/8.jpg", CV_LOAD_IMAGE_GRAYSCALE))
    assert_equal 3, pais.size
  end
end
