# frozen_string_literal: true

class Checkmark
  module Read
    class Base
      extend Registerable[Read]

      def initialize(content)
        @content = content
      end
    end

    require_relative 'read/json'
    require_relative 'read/md'
    require_relative 'read/quiz'
  end
end
