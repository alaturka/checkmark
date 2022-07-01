# frozen_string_literal: true

module Checkmark
  module Layouts
    module TeX
      Base = Layout[self]

      require_relative "tex/default"

      Layouts[:tex] = self
    end
  end
end
