# frozen_string_literal: true

module Checkmark
  class Layout
    attr_reader :type, :variant

    def initialize(type, variant)
      @type    = type
      @variant = variant

      @dir     = File.join(__dir__, "layouts", type, variant)
    end

    def template(name = nil)
      name ? File.join(@dir, "#{name}.erb") : @dir
    end

    def template?(...)
      File.exist?(templat(...))
    end

    def to_s
      "#{type}/#{variant}"
    end

    def to_sym
      to_s.to_sym
    end
  end

  def self.layout(type, variant = "default")
    Layout.new(type, variant)
  end

  def self.layout?(...)
    File.exist?(Layout.new(...).template)
  end
end
