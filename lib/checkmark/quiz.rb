# frozen_string_literal: true

module Checkmark
  class Quiz
    include ForwardableArray.new :@items

    attr_reader :meta, :items

    def initialize(meta, items = [])
      @meta = meta
      @items = items
    end

    def shuffle!
      tap { items.each(&:shuffle!) }
    end
  end
end
