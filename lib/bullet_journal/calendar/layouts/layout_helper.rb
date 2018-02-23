# frozen_string_literal: true

module BulletJournal
  ##
  # Contains methods for easier layouting pdf documents.
  #
  module LayoutHelper

    def split_horizontal(position, options = {}, &block)
      collector = Collector.new
      collector.record_block(&block)
      bounding_box([0, position], width: width, height: height - position) do
        collector.recorded_methods[:top].call
      end
      bounding_box([0, 0], width: width, height: position) do
        collector.recorded_methods[:bottom].call
      end
    end

    def split_vertical(position, options = {}, &block)
      collector = Collector.new
      collector.record_block(&block)
      bounding_box([0, 0], width: position) do
        collector.recorded_methods[:left].call
      end
      bounding_box([position, 0], width: width - position) do
        collector.recorded_methods[:right].call
      end
    end

    def dotted_background
      fill_color GRAY
      x = 0
      while x < bounds.width
        y = 0
        while y < bounds.height
          fill_circle [x, y], 0.5
          y += 5.mm
        end
        x += 5.mm
      end
      fill_color BLACK
    end

    def create_grid(x, y)
      x.times do |i|
        y.times do |j|
          bounding_box([bounds.width / x * i, bounds.height / y * (j + 1)], width: bounds.width / x, height: bounds.height / y) do
            yield i, j
          end
        end
      end
    end
  end
end
