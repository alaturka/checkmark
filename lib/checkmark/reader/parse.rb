# frozen_string_literal: true

module Checkmark
  class Reader
    class Parser
      extend Queryable

      AE = ["A", "B", "C", "D", "E"].freeze

      Context = Struct.new(:origin, :item, :nitem, :question, :nquestion, keyword_init: true) do
        def to_s
          [].tap do |strings|
            strings << origin.to_s                if origin
            strings << "Item #{item + 1}"         if item && nitem > 1
            strings << "Question #{question + 1}" if question && nquestion > 1
          end.join(": ")
        end
      end

      attr_reader :settings

      def initialize(settings)
        @settings = settings.dup.freeze
      end

      def call(...)
        raise NotImplementedError
      end

      private

      def new_sanitized_choices(klass, hash, context)
        choice, = hash.detect { |_, text| text.empty? }
        error("Empty choice: #{choice}", context) if choice

        klass.new(**hash).tap do |choices|
          duplicate = choices.duplicate
          error("Duplicate choice found: #{duplicate}", context) if duplicate

          error("Inconsistent number of choices", context) if @prev_choices && prev_choices.size != choices.size

          @prev_choices = choices
        end
      end

      def error(message, context)
        raise Error, context.to_s.empty? ? message : "#{context}: #{message}"
      end
    end
  end

  require_relative "parse/json"
  require_relative "parse/md"
end
