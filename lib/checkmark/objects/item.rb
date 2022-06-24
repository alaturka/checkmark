# frozen_string_literal: true

class Checkmark
  class Item
    include ForwardableArray.(:@questions)

    attr_reader :text, :questions

    def initialize(text, questions = [])
      @text = text
      @questions = questions
    end

    def shuffle!
      tap { questions.shuffle!.each(&:shuffle!) }
    end
  end
end
