# frozen_string_literal: true

class Checkmark
  module Write
    class Base
      extend Registerable[Write]
    end

    require_relative 'write/html'
    require_relative 'write/json'
    require_relative 'write/pdf'
    require_relative 'write/tex'
  end
end
