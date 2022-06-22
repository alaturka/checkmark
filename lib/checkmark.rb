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
  attr_reader :source, :read, :process, :settings, :bank

  def initialize(source, reader:, processors: [])
    @source     = source
    @reader     = reader
    @processors = processors

    @bank       = load
  end

  def call(writer:, emitter: nil)
    writer.(emitter.(bank))
  end

  private

  def load
    reader.(source) # FIXME: processors
  end

  class << self
    def call(infile, outfile, emit: nil, processes: [], settings: {})
      reader     = Read.handler_for_type(infile, settings.for(:read))
      writer     = Write.handler_for_filetype!(outfile, settings.for(:write))
      emitter    = Emit.handler(emit, settings.for(:emit))
      processors = processes.map { Process.handler(_1, settings.for(:process)) }

      new(Content.(infile), reader: reader, processors: processors).tap do |instance|
        File.write(outfile, instance.(writer: writer, emitter: emitter))
      end
    end

    # rubocop:disable Naming/MethodName
    def ABCD(*args, **kwargs)
      call(*args, **kwargs, emit: :random4)
    end

    def AB(*args, **kwargs)
      call(*args, **kwargs, emit: :random2)
    end

    def A(*args, **kwargs)
      call(*args, **kwargs, emit: :random1)
    end
    # rubocop:enable Naming/MethodName
  end
end
