# frozen_string_literal: true

module Checkmark
  def self.layout!(type, variant = "default")
    dir = File.join(__dir__, "layouts", type)
    raise "No such layout type found: #{dir}" unless File.exist?(dir)

    file = File.join(dir, "#{variant}.erb")
    raise "No such template file for type #{type}: #{file}" unless File.exist?(file)

    File.read(file)
  end
end
