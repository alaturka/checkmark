# frozen_string_literal: true

module Checkmark
  module Layouts
    module TeX
      Base = Template[self]

      require_relative "tex/default"
    end
  end
end
