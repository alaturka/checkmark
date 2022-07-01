# frozen_string_literal: true

module Checkmark
  def self.layout(type, variant = "default")
    File.join(__dir__, "layouts", type, "#{variant}.erb")
  end

  def self.layout?(...)
    File.exist?(layout(...))
  end
end
