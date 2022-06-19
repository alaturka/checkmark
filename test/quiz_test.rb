# frozen_string_literal: true

require_relative './test_helper'

module Checkmark
  class QuizTest < Minitest::Test
    TESTDATA = {
      meta:  {
        title: 'Title'
      },
      items: [
        {
          questions: [
            {
              stem:    'question 1',
              choices: {
                A: 'q1 A',
                B: 'q1 B',
                C: 'q1 C',
                D: 'q1 D',
                E: 'q1 E'
              }
            }
          ]
        },
        {
          text:      'question21 and question 22',
          questions: [
            {
              stem:    'question 21',
              choices: {
                A: 'q21 A',
                B: 'q21 B',
                C: 'q21 C',
                D: 'q21 D',
                E: 'q21 E'
              }
            },
            {
              stem:    'question 22',
              choices: {
                A: 'q22 A',
                B: 'q22 B',
                C: 'q22 C',
                D: 'q22 D',
                E: 'q22 E'
              }
            }
          ]
        },
        {
          questions: [
            {
              stem:    'question 3',
              choices: {
                A: 'q3 A',
                B: 'q3 B',
                C: 'q3 C',
                D: 'q3 D',
                E: 'q3 E'
              }
            }
          ]
        },
        {
          questions: [
            {
              stem:    'question 4',
              choices: {
                A: 'q4 A',
                B: 'q4 B',
                C: 'q4 C',
                D: 'q4 D',
                E: 'q4 E'
              }
            }
          ]
        },
        {
          questions: [
            {
              stem:    'question 5',
              choices: {
                A: 'q5 A',
                B: 'q5 B',
                C: 'q5 C',
                D: 'q5 D',
                E: 'q5 E'
              }
            }
          ]
        },
        {
          questions: [
            {
              stem:           'question 6',
              compactchoices: { A: 'q6 A', B: 'q6 B', C: 'q6 C', D: 'q6 D', E: 'q6 E' }
            }
          ]
        }
      ]
    }.freeze

    def test_construction
      quiz(TESTDATA)
    end

    def test_forwardable
      assert_equal(TESTDATA[:items].size, quiz(TESTDATA).size)
    end

    def test_shuffle
      quiz(TESTDATA).shuffle!
    end

    private

    def choices(correct = nil, **hash)
      klass = Choices if hash.key?(:choices) && !hash.key?(:compactchoices)
      klass = CompactChoices if !hash.key?(:choices) && hash.key?(:compactchoices)

      raise ArgumentError, "No valid choices found: #{hash}" unless klass

      klass.new(correct, **hash)
    end

    def quiz(testdata)
      Quiz.new(
        testdata[:meta],
        testdata[:items].map do |item_hash|
          Item.new(
            item_hash[:text],
            item_hash[:questions].map do |question_hash|
              Question.new(
                question_hash[:stem],
                choices(**question_hash)
              )
            end
          )
        end
      )
    end
  end
end
