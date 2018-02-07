# frozen_string_literal: true

require 'bullet_journal/util/collector'

module BulletJournal
  module Split
    def horizontal_split(position, options = {}, &block)
      collector = Collector.new
      collector.record_block block
      bounding_box([0, position], width: @width, height: @height - position) do
        collector.recorded_methods[:top].call
      end
      bounding_box([0, 0], width: @width, height: position) do
        collector.recorded_methods[:bottom].call
      end
    end
  end
end
