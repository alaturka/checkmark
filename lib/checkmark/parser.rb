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

    Context = Struct.new :origin, :item, :question, :choice, keyword_init: true

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
      items = content.strip!.split(RE[:item_sep]).each_with_index.map do |chunk, i|
        parse_item(chunk, Context.new(origin: options[:origin], item: i))
      end

      Quiz.new({}, items)
    end

    def parse_item(content, context)
      text, *rest = content.strip!.split(RE[:question_sep])

      questions = rest.each_with_index.map do |chunk, i|
        parse_question(chunk, context.tap { |a| a.question = i })
      end

      Item.new(text, questions)
    end

    def parse_question(content, context)
      stem, rest = content.split(RE[:choice_start], 2)
      error 'No choices found' unless rest

      stem.strip!
      rest.strip!

      Question.new(stem, parse_choices(rest, context))
    end

    def parse_choices(content, context) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      pattern, klass = content.include?("\n") ? [Choices, RE[:choice_block]] : [ShortChoices, RE[:choice_line]]

      chunks = content.split pattern

      labels = AE.dup
      hash = {}

      until chunks.empty?
        hash[label = labels.shift.to_sym] = chunks.shift.strip
        context.choice = label

        break if labels.empty? || chunks.empty?

        expected, got = labels.first, chunks.shift

        error "Out of order choice: expected choice #{expected}, got choice #{got}" unless expected == got
      end

      klass.new(**hash)
    end

    def error(message)
      raise Error, message
    end
  end
end
