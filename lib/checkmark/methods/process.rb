# frozen_string_literal: true

module Checkmark
  module Process
    Base = Method[self]

    require_relative 'process/run'
  end
end
