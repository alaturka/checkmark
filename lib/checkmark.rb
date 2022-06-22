# frozen_string_literal: true

require_relative 'checkmark/support'
require_relative 'checkmark/error'
require_relative 'checkmark/version'

require_relative 'checkmark/emit'
require_relative 'checkmark/model'
require_relative 'checkmark/process'
require_relative 'checkmark/read'
require_relative 'checkmark/render'
require_relative 'checkmark/write'

class Checkmark
  attr_reader :source, :read, :process, :settings, :banks

  def initialize(source, read:, process: [], settings: {})
    @source   = source
    @read     = read
    @process  = process
    @settings = settings

    load
  end

  def call(write:, emit: nil)
    write.(emit.(bank))
  end

  private

  def load
    @banks = emit read.(source) # FIXME: processors
  end

  def emit(bank)
    [bank]
  end

  class << self
    def call(infile, outfile, emit: nil, process: [], settings: {})
      new(Content.(infile), read: Read.handler!(infile), process: process, settings: settings).tap do |instance|
        result = instance.(write: Write.handler!(outfile), emit: emit)
        File.write(outfile, result)
      end
    end
  end
end
