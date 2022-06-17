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

    def to_s
      [stem, *choices.map(&:to_s)].join("\n")
    end
  end
end
