# frozen_string_literal: true

class Checkmark
  module Read
    class MD
      AE = %w[A B C D E].freeze
      RE = {
        item_sep:     /^===+$/x,
        question_sep: /^---+$/x,
        choice_start: /\n[ \t]*\n#{AE.first}\)\s+/x,
        choice_line:  /\b([#{AE[1]}-#{AE.last}])\)\s+/x,
        choice_block: /^([#{AE[1]}-#{AE.last}])\)\s+/x
      }.freeze

      Error = Class.new Error

      Context = Struct.new :origin, :item, :nitem, :question, :nquestion, keyword_init: true do
        def to_s # rubocop:disable Metrics/AbcSize
          [].tap do |strings|
            strings << origin.to_s                if origin
            strings << "Item #{item + 1}"         if item && nitem > 1
            strings << "Question #{question + 1}" if question && nquestion > 1
          end.join ': '
        end
      end

      attr_reader :raw, :options

      def initialize(raw, **options)
        @raw = raw
        @options = options
      end

      def call
        parse_quiz(raw, Context.new(origin: options[:origin]))
      end

      private

      def parse_quiz(content, context)
        iter = content.split(RE[:item_sep]).map!(&:strip!).each_with_index
        context.nitems = iter.size

        items = iter.map do |chunk, i|
          error('Empty item', context) if chunk.empty?

          parse_item(chunk, context.tap { _1.item = i })
        end

        Quiz.new({}, items)
      end

      def parse_item(content, context) # rubocop:disable Metrics/AbcSize
        text, *rest = content.split(RE[:question_sep])

        error('Item text missing', context) if text.strip!.empty?

        iter = rest.map!(&:strip!).each_with_index
        context.nquestions = iter.size

        questions = iter.map do |chunk, i|
          error('Empty question', context) if chunk.empty?

          parse_question(chunk, context.tap { _1.question = i })
        end

        Item.new(text, questions)
      end

      def parse_question(content, context)
        stem, rest = content.split(RE[:choice_start], 2).map!(&:strip!)

        error('Question stem missing', context) if stem.empty?
        error('No choices found', context) unless rest

        Question.new(stem, parse_choices(rest, context))
      end

      def parse_choices(content, context) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        pattern, klass = content.include?("\n") ? [Choices, RE[:choice_block]] : [ShortChoices, RE[:choice_line]]

        chunks = content.split(pattern).map(&:strip!)

        labels = AE.dup
        hash = {}

        until chunks.empty?
          hash[labels.shift.to_sym] = chunks.shift
          break if labels.empty? || chunks.empty?

          expected, got = labels.first, chunks.shift

          error("Out of order choice: expected choice #{expected}, got choice #{got}", context) unless expected == got
        end

        new_sanitized_choices(klass, hash, context)
      end

      def new_sanitized_choices(klass, hash, context)
        choice, = hash.detect { |_, text| text.empty? }
        error("Empty choice: #{choice}", context) if choice

        klass.new(**hash).tap do |choices|
          duplicate = choices.duplicate
          error("Duplicate choice found: #{duplicate}", context) if duplicate

          error('Inconsistent number of choices', context) if @prev_choices && prev_choices.size != choices.size

          @prev_choices = choices
        end
      end

      def error(message, context)
        raise Error, context.to_s.empty? ? message : "#{context}: #{message}"
      end
    end
  end
end
