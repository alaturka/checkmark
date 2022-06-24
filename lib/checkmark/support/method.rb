# frozen_string_literal: true

class Checkmark
  class Method
    def self.[](modul, &block)
      Class.new(self, &block).tap { |klass| klass.extend Registerable[modul] }
    end

    attr_reader :settings

    def initialize(settings)
      @settings = settings.dup.freeze
    end

    def call(...)
      raise NotImplementedError
    end
  end
end
