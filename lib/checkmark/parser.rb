# frozen_string_literal: true

module Checkmark
  class Parser
    ITEM_SEP_PATTERN      = /^===+$/x
    QUESTION_SEP_PATTERN  = /^---+$/x

    CHOICE_LETTER_SET     = %w[A B C D E].freeze

    CHOICE_START_PATTERN  = /\n[ \t]*\n#{CHOICE_LETTER_SET.first}\)\s+/x
    CHOICE_LINE_PATTERN   = /\b([#{CHOICE_LETTER_SET[1]}-#{CHOICE_LETTER_SET.last}])\)\s+/x
    CHOICE_BLOCK_PATTERN  = /^([#{CHOICE_LETTER_SET[1]}-#{CHOICE_LETTER_SET.last}])\)\s+/x

    Error = Class.new Error

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

    def parse_quiz(content)
      items = content.strip!.split(ITEM_SEP_PATTERN).map { |chunk| parse_item(chunk) }

      Quiz.new({}, items)
    end

    def parse_item(content)
      text, *rest = content.strip!.split(QUESTION_SEP_PATTERN)

      Item.new(text, rest.map { |chunk| parse_question(chunk) })
    end

    def parse_question(content)
      stem, rest = content.split(CHOICE_START_PATTERN, 2)
      raise 'No choices found' unless rest

      stem.strip!
      rest.strip!

      Question.new(stem, parse_choices(rest))
    end

    def parse_choices(content) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      pattern, klass = content.include?("\n") ? [Choices, CHOICE_BLOCK_PATTERN] : [ShortChoices, CHOICE_LINE_PATTERN]

      chunks = content.split pattern

      labels = CHOICE_LETTER_SET.dup
      hash = {}

      until chunks.empty?
        hash[labels.shift.to_sym] = chunks.shift.strip
        break if labels.empty? || chunks.empty?

        expected, got = labels.first, chunks.shift

        raise Error, "Out of order choice: expected choice #{expected}, got choice #{got}" unless expected == got
      end

      klass.new(**hash)
    end
  end
end
