# frozen_string_literal: true

module Checkmark
  class Layout
    def self.[](modul, &block)
      Class.new(self, &block).tap { _1.extend(Registerable[modul]) }
    end
  end

  module Layouts
    @layouts = {}

    def self.[]=(name, klass)
      raise Error, "Attempt to overwrite layout handler for: #{name}" if @layouts.key?(name = name.to_sym)

      @layouts[name] = klass
    end

    def self.[](name)
      raise Error, "Unknown layout handler for: #{name}" unless @layouts.key?(name = name.to_sym)

      @layouts[name.to_sym]
    end

    def self.builder!(name, layout)
      self[name].handler!(layout)
    end

    require_relative "layouts/html"
    require_relative "layouts/sil"
    require_relative "layouts/tex"

    @layouts.freeze
  end
end
