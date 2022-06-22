# frozen_string_literal: true

class Checkmark
  module Shuffle
    class Base
      extend Registerable[Shuffle]
    end

    require_relative 'shuffle/random'
  end
end
