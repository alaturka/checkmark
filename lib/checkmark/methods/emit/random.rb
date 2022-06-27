# frozen_string_literal: true

module Checkmark
  module Emit
    class Random < Base
      register :random

      def call(_bank, _name: nil, _publisher: nil)
        nil
      end
    end
  end
end
