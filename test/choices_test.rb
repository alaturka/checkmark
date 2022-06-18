# frozen_string_literal: true

require_relative './test_helper'

module Checkmark
  class ChoicesTest < Minitest::Test
    TESTDATA = { A: 'first', B: 'second', C: 'third', D: 'fourth', E: 'fifth' }.freeze

    def test_construction_implicit
      choices = Choices[**TESTDATA]

      assert_equal(:A, choices.correct)
      assert_equal('first', choices.correct_choice)
    end

    def test_construction_explicit
      choices = Choices[:C, **TESTDATA]

      assert_equal(:C, choices.correct)
      assert_equal('third', choices.correct_choice)
    end

    def test_shuffle_implicit
      choices = Choices[**TESTDATA]

      correct_choice_initial = choices.correct_choice

      5.times do
        choices.shuffle!
        assert_equal(choices.correct_choice, correct_choice_initial)
      end
    end

    def test_shuffle_explicit
      choices = Choices[:E, **TESTDATA]

      correct_choice_initial = choices.correct_choice

      5.times do
        choices.shuffle!
        assert_equal(choices.correct_choice, correct_choice_initial)
      end
    end
  end
end
