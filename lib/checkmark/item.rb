# frozen_string_literal: true

module Checkmark
  class Item
    include ForwardableArray.(:@questions)

    attr_reader :text, :questions

    def initialize(text, questions = [])
      @text = text
      @questions = questions
    end

    def shuffle!
      questions.shuffle!
      tap { questions.each(&:shuffle!) }
    end
  end
end
