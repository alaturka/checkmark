# frozen_string_literal: true

class Checkmark
  module Read
    Base = Method[self]

    require_relative 'read/json'
    require_relative 'read/md'
    require_relative 'read/quiz'
  end
end
