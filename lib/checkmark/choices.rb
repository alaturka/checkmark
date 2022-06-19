# frozen_string_literal: true

require 'delegate'

module Checkmark
  class Choices < DelegateClass(::Hash)
    attr_reader :correct

    def initialize(correct = nil, **choices)
      super(choices)

      @correct =
        if correct
          raise ArgumentError, "Invalid key: #{correct}" unless choices.key? correct

          correct
        else
          keys.first
        end
    end

    def shuffle
      lookup = keys.zip(new_keys = keys.shuffle).to_h.invert
      self.class.new(lookup[@correct], **keys.zip(values_at(*new_keys)).to_h)
    end

    def shuffle!
      @correct = (new_choices = shuffle).correct
      tap { replace new_choices }
    end

    def correct_choice
      self[correct]
    end

    alias each_choice each_value

    def duplicate
      values.detect { |e| values.count(e) > 1 }
    end

    def self.[](...)
      new(...)
    end
  end

  ShortChoices = Class.new Choices
end
