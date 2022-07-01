# frozen_string_literal: true

module Checkmark
  module Writers
    module Sil
      Base = Writer[self]

      require_relative "sil/default"

      Writers[:sil] = self
    end
  end
end
