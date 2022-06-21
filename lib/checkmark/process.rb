# frozen_string_literal: true

class Checkmark
  module Process
    class Base
      extend Registerable[Process]
    end

    require_relative 'process/run'
  end
end
