# frozen_string_literal: true

class Checkmark
  module Emit
    Base = Extension[self]

    require_relative 'emit/random'
  end
end
