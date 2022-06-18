# frozen_string_literal: true

module Checkmark
  class Parser
    attr_reader :raw, :options

    def initialize(raw, **options)
      @raw = raw
      @options = options
    end
  end
end
