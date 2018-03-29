# frozen_string_literal: true

require 'prawn/measurements'

module BulletJournal
  ##
  # Contains methods for easier layouting pdf documents.
  #
  module LayoutHelper
    include Colors
    include Prawn::Measurements

    def split_horizontal(options = {}, &block)
      position = options[:at] || 0

      collector = Collector.new(&block)
      bounding_box([0, position], width: width, height: height - position) do
        collector.recorded_methods[:top].call
      end
      bounding_box([0, 0], width: width, height: position) do
        collector.recorded_methods[:bottom].call
      end
    end

    def split_vertical(options = {}, &block)
      position = options[:at] || 0

      collector = Collector.new(&block)
      bounding_box([0, 0], width: position) do
        collector.recorded_methods[:left].call
      end
      bounding_box([position, 0], width: width - position) do
        collector.recorded_methods[:right].call
      end
    end

    def dotted_background
      fill_color GRAY
      distance = mm2pt(5)
      0.step(bounds.width, distance) do |x|
        0.step(bounds.height, distance) do |y|
          fill_circle [x, y], 0.5
        end
      end
      fill_color BLACK
    end

    def create_grid(x, y, &block)
      width = bounds.width / x
      height = bounds.height / y
      x.times do |i|
        y.times do |j|
          create_grid_item i, j, width, height, &block
        end
      end
    end

    def create_grid_item(i, j, width, height)
      position = [width * i, height * (j + 1)]
      bounding_box(position, width: width, height: height) do
        yield i, j
      end
    end
  end
end
