# frozen_string_literal: true

class Checkmark
  module Emit
    class Random < Base
      register :random

      def call(_bank, _name: nil, _publisher: nil)
        nil
      end
    end
  end
end
