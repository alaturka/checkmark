# frozen_string_literal: true

class Checkmark
  module Emit
    class Base
      extend Registerable[Emit]
    end

    require_relative 'emit/random'
  end
end
