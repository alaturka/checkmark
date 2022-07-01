# frozen_string_literal: true

module Checkmark
  module Layouts
    module Sil
      Base = Layout[self]

      require_relative "sil/default"

      Layouts[:sil] = self
    end
  end
end
