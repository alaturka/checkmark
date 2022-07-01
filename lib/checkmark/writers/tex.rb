# frozen_string_literal: true

module Checkmark
  module Writers
    module TeX
      Base = Writer[self]

      require_relative "tex/default"

      Writers[:tex] = self
    end
  end
end
