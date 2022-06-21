# frozen_string_literal: true

class Checkmark
  module Render
    class Base
      def initialize
        raise NotImplementedError
      end
    end

    require_relative 'render/html'
    require_relative 'render/tex'
  end
end
