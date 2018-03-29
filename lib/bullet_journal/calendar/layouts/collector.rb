# frozen_string_literal: true

module BulletJournal
  ##
  # Class which records all methods calls.
  #
  class CollectorProxy < BasicObject
    def initialize(recorder)
      @recorder = recorder
    end

    private

    # rubocop:disable Style/MethodMissing
    def method_missing(method, *_args, &block)
      @recorder[method] = block
    end
    # rubocop:enable Style/MethodMissing

    def respond_to_missing?(_method_name, _include_private = false)
      true
    end
  end

  ##
  # The Collector records a block given and is able to playback the
  # called methods.
  #
  class Collector
    def initialize(&block)
      @recorder = {}
      record_block(&block) if block
    end

    def record_block
      proxy = CollectorProxy.new @recorder
      yield proxy
    end

    def recorded_methods
      @recorder
    end
  end
end
