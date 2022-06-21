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
  attr_reader :source, :reader, :processors, :settings, :banks

  def initialize(source, reader:, processors: [], settings: {})
    @source     = source
    @reader     = reader
    @processors = processors
    @settings   = settings

    load
  end

  def perform(writer)
    writer.(banks)
  end

  private

  def load
    @banks = emit reader.(source) # FIXME: processors
  end

  def emit(bank)
    [bank]
  end

  class << self
    def new_from_file(file, **kwargs)
      new(Content.(file), reader: Read.handler!(file), **kwargs)
    end

    def call(infile, outfile, processors: [], settings: {})
      new(Content.(infile), reader: Read.handler!(infile), processors: processors, settings: settings).tap do |instance|
        result = instance.perform Write.handler!(outfile)
        File.write(outfile, result)
      end
    end
  end
end
