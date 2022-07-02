# frozen_string_literal: true

module Checkmark
  class Method
    extend Queryable

    attr_reader :settings

    def initialize(settings)
      @settings = settings.dup.freeze
    end

    def call(...)
      raise NotImplementedError
    end
  end

  require_relative "methods/emit"
  require_relative "methods/process"
  require_relative "methods/render"
end
