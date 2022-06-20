# frozen_string_literal: true

require_relative '../test_helper'

class Checkmark
  class ChoicesTest < Minitest::Test
    TESTDATA = { A: 'first', B: 'second', C: 'third', D: 'fourth', E: 'fifth' }.freeze
    Klass = Choices

    def test_construction_implicit
      choices = Klass[**TESTDATA]

      assert_equal(:A, choices.correct)
      assert_equal('first', choices.correct_choice)
    end

    def test_construction_explicit
      choices = Klass[:C, **TESTDATA]

      assert_equal(:C, choices.correct)
      assert_equal('third', choices.correct_choice)
    end

    def test_like_hash
      choices = Klass[**TESTDATA]

      assert_equal(TESTDATA.size, choices.size)

      assert_equal('first', choices[:A])
      assert_equal('fifth', choices[:E])
    end

    def test_shuffle_implicit
      choices = Klass[**TESTDATA]

      correct_choice_initial = choices.correct_choice

      5.times do
        choices.shuffle!
        assert_equal(choices.correct_choice, correct_choice_initial)
      end
    end

    def test_shuffle_explicit
      choices = Klass[:E, **TESTDATA]

      correct_choice_initial = choices.correct_choice

      5.times do
        choices.shuffle!
        assert_equal(choices.correct_choice, correct_choice_initial)
      end
    end
  end

  class ShortChoicesTest < ChoicesTest
    Klass = ShortChoices
  end
end
