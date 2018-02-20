# frozen_string_literal: true

module BulletJournal
  class CollectorProxy < BasicObject
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

    def record_block block
      if block.nil?
        raise Exception.new
      end
      proxy = CollectorProxy.new @recorder
      proxy.instance_eval(&block)
    end

    def recorded_methods
      @recorder
    end
  end
end
