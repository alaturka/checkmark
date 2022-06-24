# frozen_string_literal: true

class Checkmark
  module Process
    Base = Method[self]

    require_relative 'process/run'
  end
end
