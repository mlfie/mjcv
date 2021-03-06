require 'mjcv/geom/point'
require 'mjcv/fitting/line_fitting'
require 'mjcv/fitting/least_median_squares_line_fitting'

module MjCV
  module CV
    class Filter
      attr_reader :origin, :vector
      def filter(pailist)
        error_ratio = 10.0 / pailist.size > 0.5 ? 0.5 : 10.0 / pailist.size
        fitting = MjCV::Fitting::LeastMedianSquaresParamSearch.new(MjCV::Fitting::LMSLineFittingModel.new(pailist.select{|pai| pai.direction == :top}), error_ratio)
        intercept, slope = fitting.search
        @origin = create_origin(intercept)
        @vector = create_vector(slope)
        pailist.select do |pai|
          nearby_line?(pai, @origin, @vector)
        end
      end
  
      def nearby_line?(pai, ori, vec)
        pai.distance_from_line(ori, vec) < pai.height * 0.5
        #TODO fix it!
        #pai.distance_from_line(ori, vec) < 28
      end
  
      def create_origin(intercept)
        MjCV::Geom::Point.new(0, intercept)
      end
      def create_vector(slope)
        MjCV::Geom::Point.new(1, slope)
      end
    end
  end
end
