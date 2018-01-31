require_relative "../util/collector.rb"

module Split
  def horizontal_split position
    collector = Collector.new
    yield collector
    bounding_box([0, $header_position], :width => @width, :height => $header_position ) do
      collector.recorder[:top].call()
    end
    bounding_box([0, $header_position], :width => @width, :height => $header_position ) do
      collector.recorder[:bottom].call()
    end
  end
end
