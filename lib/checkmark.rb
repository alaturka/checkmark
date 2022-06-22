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
  attr_reader :source, :reader, :processors, :settings

  def initialize(source, reader:, processors: EMPTY_ARRAY)
    @source     = source
    @reader     = reader
    @processors = processors
  end

  def call(writer:, emitter: nil)
    write(writer, emit(emitter, load(source)))
  end

  def read(reader, source)
    reader.(source)
  end

  def process(processors, bank)
    bank.tap { processors.each { |processor| processor.(bank) } }
  end

  def write(writer, banks)
    writer.(banks)
  end

  def emit(emitter, bank)
    emitter ? emitter.(bank) : [bank]
  end

  def load(source)
    process(processors, read(reader, source))
  end

  class << self
    def call(infile, outfile, emit: nil, processes: EMPTY_ARRAY, settings: EMPTY_HASH)
      settings   = Settings.new settings

      reader     = Read.handler_for_filetype!(infile, settings.for(:read))
      writer     = Write.handler_for_filetype!(outfile, settings.for(:write))
      emitter    = Emit.handler(emit, settings.for(:emit))
      processors = processes.map { Process.handler(_1, settings.for(:process)) }

      new(Content.(infile), reader: reader, processors: processors).tap do |instance|
        File.write(outfile, instance.(writer: writer, emitter: emitter))
      end
    end

    # rubocop:disable Naming/MethodName
    def ABCD(*args, **kwargs)
      call(*args, **emit_setup(kwargs, 4))
    end

    def AB(*args, **kwargs)
      call(*args, **emit_setup(kwargs, 2))
    end

    def A(*args, **kwargs)
      call(*args, **emit_setup(kwargs, 1))
    end
    # rubocop:enable Naming/MethodName

    private

    def emit_setup(kwargs, nbank, emit = :random)
      kwargs[:emit] = emit
      (kwargs[:setting][:emit] ||= {})[:nbank] = nbank
      kwargs.freeze
    end
  end
end
