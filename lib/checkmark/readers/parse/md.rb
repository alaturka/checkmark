# frozen_string_literal: true

module Checkmark
  class Reader
    class MD < Parser
      register :md

      RE = {
        item_sep:     /^===+$/x,
        lead_sep:     /^[.][.][.]+$/x,
        question_sep: /^---+$/x,
        choice_start: /\n[ \t]*\n#{AE.first}\)\s+/x,
        choice_line:  /\b([#{AE[1]}-#{AE.last}])\)\s+/x,
        choice_block: /^([#{AE[1]}-#{AE.last}])\)\s+/x,
      }.freeze

      def call(content)
        quiz(content, Context.new(origin: content.is_a?(Content) ? content.origin : nil))
      end

      private

      def quiz(text, context)
        iter = text.split(RE[:item_sep]).map!(&:strip!).each_with_index
        context.nitems = iter.size

        items = iter.map do |chunk, i|
          error("Empty item", context) if chunk.empty?

          item(chunk, context.tap { _1.item = i })
        end

        Quiz.new({}, items)
      end

      def item(text, context)
        body, rest = text.split(RE[:lead_sep], 2)

        error("Item body missing", context) if body.strip!.empty?

        iter = rest.split(RE[:question_sep]).map!(&:strip!).each_with_index
        context.nquestions = iter.size

        questions = iter.map do |chunk, i|
          error("Empty question", context) if chunk.empty?

          question(chunk, context.tap { _1.question = i })
        end

        Item.new(body, questions)
      end

      def question(text, context)
        stem, rest = text.split(RE[:choice_start], 2).map!(&:strip!)

        error("Question stem missing", context) if stem.empty?
        error("No choices found", context) unless rest

        Question.new(stem, choices(rest, context))
      end

      def choices(text, context)
        pattern, klass = text.include?("\n") ? [Choices, RE[:choice_block]] : [ShortChoices, RE[:choice_line]]

        chunks = text.split(pattern).map(&:strip!)

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
    end
  end
end
