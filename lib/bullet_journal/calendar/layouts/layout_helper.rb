# frozen_string_literal: true

require 'prawn/measurements'

module BulletJournal
  ##
  # Contains methods for easier layouting pdf documents.
  #
  module LayoutHelper
    include Colors
    include Prawn::Measurements

    def split_horizontal(options, &block)
      top_height = extract_position(options, height)
      bottom_height = height - top_height

      collector = Collector.new(&block)
      split_horizontal_box(height, top_height, collector, :top)
      split_horizontal_box(bottom_height, bottom_height, collector, :bottom)
    end

    def split_horizontal_box(y_position, box_height, collector, method)
      block = collector.recorded_methods[method]
      return unless block
      bounding_box([0, y_position], width: width, height: box_height) do
        block.call
      end
    end

    def split_vertical(options, &block)
      left_width = extract_position(options, width)
      right_width = width - left_width

      collector = Collector.new(&block)
      split_vertical_box(0, left_width, collector, :left)
      split_vertical_box(left_width, right_width, collector, :right)
    end

    def split_vertical_box(x_position, box_width, collector, method)
      block = collector.recorded_methods[method]
      return unless block
      bounding_box([x_position, height], width: box_width, height: height) do
        block.call
      end
    end

    def extract_position(options, full)
      percent = options[:percent]
      if percent
        full * percent / 100
      else
        options[:at] || 0
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

    def background(color)
      fill_color color
      fill_rectangle(bounds.top_left, width, height)
    end

    def grid(x, y, &block)
      width = bounds.width / x
      height = bounds.height / y
      x.times do |i|
        y.times do |j|
          grid_item i, j, width, height, &block
        end
      end
    end

    def grid_item(i, j, width, height)
      position = [width * i, height * (j + 1)]
      bounding_box(position, width: width, height: height) do
        yield i, j
      end
    end

    def box(orientation, txt)
      font_size 9
      pad(5) { text txt, align: orientation }
    end

    def border(first_point, *points)
      stroke do
        move_to(bounds.send(first_point))
        points.each { |to| line_to(bounds.send(to)) }
      end
    end

    def width
      bounds.width
    end

    def height
      bounds.height
    end
  end
end
