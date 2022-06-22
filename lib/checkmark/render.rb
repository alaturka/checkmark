# frozen_string_literal: true

class Checkmark
  module Render
    Base = Extension[self]

    require_relative 'render/html'
    require_relative 'render/tex'
  end
end
