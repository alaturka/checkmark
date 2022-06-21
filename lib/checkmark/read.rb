# frozen_string_literal: true

class Checkmark
  module Read
    class Base
      extend Registerable[Read]

      attr_reader :options

      def initialize(content, **options)
        super()

        @content = content
        @options = options
      end
    end

    require_relative 'read/json'
    require_relative 'read/md'
    require_relative 'read/quiz'
  end
end
