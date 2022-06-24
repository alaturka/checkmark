# frozen_string_literal: true

class Checkmark
  module Write
    Base = Method[self]

    require_relative 'write/html'
    require_relative 'write/tex'
  end
end
