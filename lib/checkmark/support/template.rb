# frozen_string_literal: true

module Checkmark
  class Template
    def self.[](modul, &block)
      Class.new(self, &block).tap { _1.extend(Registerable[modul]) }
    end

    #   attr_reader :type, :layout, :dir

    #   def initialize(type, layout = "default")
    #     @type   = type
    #     @layout = layout
    #     @dir    = File.join(__dir__, "layouts", type, layout)
    #   end

    #   def [](name)
    #     File.join(dir, "#{name}.erb").tap do
    #       raise Error, "No template found in #{self}: #{name}" unless File.exist?(_1)
    #     end
    #   end

    #   def exist?(name = nil)
    #     name ? File.exist?(self[name]) : Dir.exist?(dir)
    #   end

    #   def to_s
    #     "#{type}/#{layout}"
    #   end

    #   def to_sym
    #     to_s.to_sym
    #   end
  end

  # def self.template(...)
  #   Template.new(...)
  # end

  # def self.template!(...)
  #   template(...).tap { raise "Missing template: #{_1}" unless _1.exist? }
  # end

  # def self.template?(type, layout = "default", name = nil)
  #   template(type, layout).exist?(name)
  # end
end
