# frozen_string_literal: true

class Checkmark
  class Bank
    include ForwardableArray.(:@items)

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
