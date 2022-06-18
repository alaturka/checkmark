# frozen_string_literal: true

module Checkmark
  class Question
    attr_reader :stem, :choices

    def initialize(stem, choices)
      @stem = stem
      @choices = choices
    end

    def shuffle!
      tap { choices.shuffle! }
    end
  end
end
