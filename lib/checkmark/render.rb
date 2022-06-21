# frozen_string_literal: true

class Checkmark
  module Render
    class Base
      extend Registerable[Render]
    end

    require_relative 'render/html'
    require_relative 'render/tex'
  end
end
