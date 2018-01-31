class Collector
  attr_reader :recorder

  def initialize
    @recorder = {}
  end

  def method_missing(m, *args, &block)
    @recorder[m] = block
  end
end
