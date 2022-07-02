# frozen_string_literal: true

module Checkmark
  class Writer
    extend Queryable

    def render
      raise NotImplementedError
    end

    def build
      raise NotImplementedError
    end
  end

  require_relative "writers/html"
  require_relative "writers/sil"
  require_relative "writers/tex"
end
