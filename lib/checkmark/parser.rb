# frozen_string_literal: true

module Checkmark
  class Parser
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
        strings = []

        strings << origin.to_s                if origin
        strings << "Item #{item + 1}"         if item && nitem.positive?
        strings << "Question #{question + 1}" if question && nquestion.positive?

        strings.join ': '
      end
    end

    attr_reader :raw, :options

    def initialize(raw, **options)
      @raw = raw
      @options = options
    end

    def call
      parse_quiz(raw)
    end

    private

    # TODO: Handle errors

    def parse_quiz(content) # rubocop:disable Metrics/AbcSize
      context = Context.new(origin: options[:origin])

      iter = content.strip!.split(RE[:item_sep]).each_with_index
      context.nitems = iter.size

      items = iter.map do |chunk, i|
        error('Empty item', context) if chunk.strip!.empty?

        parse_item(chunk, context.tap { |c| c.item = i })
      end

      Quiz.new({}, items)
    end

    def parse_item(content, context) # rubocop:disable Metrics/AbcSize
      text, *rest = content.split(RE[:question_sep])

      error('Item text missing', context) if text.strip!.empty?

      iter = rest.each_with_index
      context.nquestions = iter.size

      questions = iter.map do |chunk, i|
        error('Empty question', context) if chunk.strip!.empty?

        parse_question(chunk, context.tap { |c| c.question = i })
      end

      Item.new(text, questions)
    end

    def parse_question(content, context)
      stem, rest = content.split(RE[:choice_start], 2)
      error('No choices found', context) unless rest

      stem.strip!
      rest.strip!

      error('Question stem missing', context) if stem.empty?

      choices = parse_choices(rest, context)
      error('Inconsistent number of choices', context) if @prev_choices && prev_choices.size != choices.size

      Question.new(stem, @prev_choices = choices)
    end

    def parse_choices(content, context) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      pattern, klass = content.include?("\n") ? [Choices, RE[:choice_block]] : [ShortChoices, RE[:choice_line]]

      chunks = content.split pattern

      labels = AE.dup
      hash = {}

      until chunks.empty?
        hash[labels.shift.to_sym] = chunks.shift.strip
        break if labels.empty? || chunks.empty?

        expected, got = labels.first, chunks.shift

        error("Out of order choice: expected choice #{expected}, got choice #{got}", context) unless expected == got
      end

      klass.new(**hash).tap do |choices|
        duplicate = choices.duplicate
        error("Duplicate choice found: #{duplicate}") if duplicate
      end
    end

    def error(message, context)
      raise Error, context.to_s.empty? ? message : "#{context}: #{message}"
    end
  end
end
