# frozen_string_literal: true

require "kramdown"

module Checkmark
  class Markdown
    def initialize(text)
      @text = text
    end
  end
end
