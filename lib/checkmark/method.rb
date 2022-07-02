# frozen_string_literal: true

module Checkmark
  class Method
    extend Inquirable

    attr_reader :settings

    def initialize(settings)
      @settings = settings.dup.freeze
    end

    def call(...)
      raise NotImplementedError
    end

    require_relative "method/emit"
    require_relative "method/process"
    require_relative "method/render"
  end
end
