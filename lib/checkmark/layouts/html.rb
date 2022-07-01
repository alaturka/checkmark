# frozen_string_literal: true

module Checkmark
  module Layouts
    module HTML
      Base = Template[self]

      require_relative "html/default"
    end
  end
end
