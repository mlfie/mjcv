require 'test/unit'
require 'test_helper'
require 'mjcv/fitting/least_median_squares_line_fitting'
require 'mjcv/fitting/line_fitting'
require 'mjcv/cv/template_matching_analyzer'
require 'mjcv/cv/template_matching_classifier'
require 'mjcv/cv/filter'
require 'mjcv/cv/selector'
require 'mjcv/cv/pai'
require 'rubygems'
require 'opencv'
require 'cv_test_helper'

include OpenCV
class TemplateMatchingClassifierTest < Test::Unit::TestCase
  include CvTestHelper
  include MjCV::CV

  def setup
    @path = File.expand_path('../../../../../olib/mjcv/cv/base', __FILE__)
    @test_path = File.expand_path('../test_img', __FILE__)
    @classifier = TemplateMatchingClassifier.new()
  end

  def test_attributes
    assert true
  end
end
