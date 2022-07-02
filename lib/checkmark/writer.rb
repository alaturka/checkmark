# frozen_string_literal: true

module Checkmark
  class Writer
    extend Inquirable

    def render
      raise NotImplementedError
    end

    def build
      raise NotImplementedError
    end

    require_relative "writer/html"
    require_relative "writer/sil"
    require_relative "writer/tex"
  end
end
