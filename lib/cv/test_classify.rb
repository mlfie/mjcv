#!/usr/bin/ruby -w0
# -*- coding: utf-8 -*-
require 'cv/template_matching_classifier'

DIRPATH = 'lib/cv/test_img/'
IMGNAME = 'test004.jpg'

tmc = CV::TemplateMatchingClassifier.new

pai_list = tmc.classify(DIRPATH + IMGNAME)
p pai_list.size
#puts pai_list[0].type

puts "IMGNAME = #{IMGNAME}"