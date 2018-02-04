# frozen_string_literal: true

require 'bullet_journal/util/collector'

module BulletJournal
  module Split
    def horizontal_split(_position)
      collector = Collector.new
      yield collector.record_methods
      bounding_box([0, $header_position], width: @width, height: $header_position) do
        collector.recorded_methods[:top].call
      end
      bounding_box([0, $header_position], width: @width, height: $header_position) do
        collector.recorded_methods[:bottom].call
      end
    end
  end
end
