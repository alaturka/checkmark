# frozen_string_literal: true

require_relative 'checkmark/support'
require_relative 'checkmark/error'
require_relative 'checkmark/version'

require_relative 'checkmark/model'
require_relative 'checkmark/process'
require_relative 'checkmark/read'
require_relative 'checkmark/render'
require_relative 'checkmark/shuffle'
require_relative 'checkmark/write'

class Checkmark
  DEFAULT = {
    process: [],
    shuffle: :random
  }.freeze

  attr_reader :source, :read, :process, :settings, :banks

  def initialize(source, read:, process: DEFAULT[:process], settings: {})
    @source   = source
    @read     = read
    @process  = process
    @settings = settings

    load
  end

  def call(write:, shuffle: DEFAULT[:shuffle])
    write.(shuffle.(bank))
  end

  private

  def load
    @banks = emit read.(source) # FIXME: processors
  end

  def emit(bank)
    [bank]
  end

  class << self
    def call(infile, outfile, shuffle: DEFAULT[:shuffle], process: DEFAULT[:process], settings: {})
      new(Content.(infile), read: Read.handler!(infile), process: process, settings: settings).tap do |instance|
        result = instance.(write: Write.handler!(outfile), shuffle: shuffle)
        File.write(outfile, result)
      end
    end
  end
end
