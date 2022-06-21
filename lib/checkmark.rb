# frozen_string_literal: true

require_relative 'checkmark/support'
require_relative 'checkmark/error'
require_relative 'checkmark/version'

require_relative 'checkmark/model'
require_relative 'checkmark/process'
require_relative 'checkmark/read'
require_relative 'checkmark/render'
require_relative 'checkmark/write'

class Checkmark
  attr_reader :quiz

  def initialize(quiz)
    @quiz = quiz

    setup
  end

  def call
    bank = read.()
    render.(bank)
    process.(bank)
    banks = emit(bank)
    write.(banks)
  end

  private

  def setup
    @reader = nil
    @renderer = nil
    @processors = []
    @writer = nil
  end

  def emit(bank)
    [bank]
  end
end
