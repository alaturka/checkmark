# frozen_string_literal: true

module Checkmark
  class Item
    include ForwardableArray.new :@questions

    attr_reader :text, :questions

    def initialize(text, questions = [])
      @text = text
      @questions = questions
    end

    def shuffle!
      questions.shuffle!
      tap { questions.each(&:shuffle!) }
    end

    def to_s
      [text, *questions.map(&:to_s)].join("\n")
    end
  end
end
