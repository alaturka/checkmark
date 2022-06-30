# frozen_string_literal: true

require "delegate"

module Checkmark
  class Content < DelegateClass(::String)
    attr_reader :origin

    def initialize(string = "", origin: nil)
      super(::String.new(string))

      @origin = origin
    end

    def self.read(file)
      new(File.read(file), origin: file)
    end

    def self.call(...)
      read(...)
    end
  end
end
