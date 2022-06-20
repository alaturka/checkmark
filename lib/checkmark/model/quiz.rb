# frozen_string_literal: true

class Checkmark
  class Quiz
    DEFAULT_TYPE = :md

    attr_reader :content, :type, :settings

    def initialize(content, type: DEFAULT_TYPE, origin: nil, settings: {})
      @content = content
      @type = type
      @origin = origin
      @settings = settings
    end
  end
end
