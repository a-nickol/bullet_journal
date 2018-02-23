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

    def method_missing(method, *_args, &block) # rubocop:disable Style/MethodMissing
      @recorder[method] = block
    end

    def respond_to_missing?(method_name, include_private = false)
      true
    end
  end

  ##
  # The Collector records a block given and is able to playback the
  # called methods.
  #
  class Collector
    def initialize
      @recorder = {}
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
