# frozen_string_literal: true

module BulletJournal
  class Proxy < BasicObject
    def initialize(recorder)
      @recorder = recorder
    end

    private

    def method_missing(method, *_args, &block)
      @recorder[method] = block
    end
  end

  class Collector
    def initialize
      @recorder = {}
    end

    def record_methods
      Proxy.new @recorder
    end

    def recorded_methods
      @recorder
    end
  end
end
