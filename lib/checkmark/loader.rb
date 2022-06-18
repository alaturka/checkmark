# frozen_string_literal: true

module Checkmark
  class Loader
    attr_reader :file, :options

    def initialize(file, **options)
      @file = file
      @options = options
    end
  end
end
