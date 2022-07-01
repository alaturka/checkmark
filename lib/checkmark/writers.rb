# frozen_string_literal: true

module Checkmark
  class Writer
    def self.[](modul, &block)
      Class.new(self, &block).tap { _1.extend(Registerable[modul]) }
    end

    def render
      raise NotImplementedError
    end

    def build
      raise NotImplementedError
    end
  end

  module Writers
    @writers = {}

    def self.[]=(name, klass)
      raise Error, "Attempt to overwrite writer for: #{name}" if @writers.key?(name = name.to_sym)

      @writers[name] = klass
    end

    def self.[](name)
      raise Error, "Unknown write handler for: #{name}" unless @writers.key?(name = name.to_sym)

      @writers[name.to_sym]
    end

    def self.builder!(name, layout)
      self[name].handler!(layout)
    end

    require_relative "writers/html"
    require_relative "writers/sil"
    require_relative "writers/tex"

    @writers.freeze
  end
end
