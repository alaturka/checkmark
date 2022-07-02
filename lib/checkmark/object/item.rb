# frozen_string_literal: true

module Checkmark
  class Item
    include Arraylike.(:@questions)

    attr_reader :text, :questions, :meta

    def initialize(text, questions = [], **meta)
      @text      = text
      @questions = questions
      @meta      = meta
    end

    def shuffle!
      tap { questions.shuffle!.each(&:shuffle!) }
    end
  end
end
