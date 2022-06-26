# frozen_string_literal: true

class Checkmark
  module Read
    Base = Method[self]

    require_relative 'read/bank'
    require_relative 'read/item'
    require_relative 'read/quiz'
  end
end
