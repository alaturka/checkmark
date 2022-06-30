# frozen_string_literal: true

require "delegate"

module Checkmark
  class Settings < DelegateClass(::Hash)
    def for(section)
      self[section.to_sym] || EMPTY_HASH
    end
  end
end
