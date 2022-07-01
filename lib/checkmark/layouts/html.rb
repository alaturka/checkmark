# frozen_string_literal: true

module Checkmark
  module Layouts
    module HTML
      Base = Layout[self]

      require_relative "html/default"

      Layouts[:html] = self
    end
  end
end
