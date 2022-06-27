# frozen_string_literal: true

class Checkmark
  module Render
    Base = Method[self]

    require_relative 'render/html'
    require_relative 'render/tex'
  end
end
