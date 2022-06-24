# frozen_string_literal: true

class Checkmark
  module Process
    Base = Extension[self]

    require_relative 'process/run'
  end
end
