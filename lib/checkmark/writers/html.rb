# frozen_string_literal: true

module Checkmark
  module Writers
    module HTML
      Base = Writer[self]

      require_relative "html/default"

      Writers[:html] = self
    end
  end
end
