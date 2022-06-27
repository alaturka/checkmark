# frozen_string_literal: true

class Checkmark
  class Bank
    include Arraylike.(:@items)

    attr_reader :items, :meta

    def initialize(items = [], **meta)
      @items = items
      @meta  = meta
    end

    def shuffle!
      tap { items.each(&:shuffle!) }
    end
  end
end
