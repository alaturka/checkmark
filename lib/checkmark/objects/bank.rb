# frozen_string_literal: true

class Checkmark
  class Bank
    include Arraylike.(:@items)

    attr_reader :meta, :items

    def initialize(items = [], **meta)
      @meta = meta
      @items = items
    end

    def shuffle!
      tap { items.each(&:shuffle!) }
    end
  end
end
