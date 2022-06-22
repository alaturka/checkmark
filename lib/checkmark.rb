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
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def call(reader:, writer:, processors: EMPTY_ARRAY, emitter: nil)
    write(emit(process(read(source, reader), processors), emitter), writer)
  end

  def read(source, reader)
    reader.(source)
  end

  def process(bank, processors)
    bank.tap { processors.each { |processor| processor.(bank) } }
  end

  def write(banks, writer)
    writer.(banks)
  end

  def emit(bank, emitter)
    emitter ? emitter.(bank) : [bank]
  end

  class << self
    { reader: Read, writer: Write, processor: Process, emitter: Emit }.each do |extension, modul|
      define_method(extension) { |name, settings| modul.handler!(name, settings) }
    end

    def processors(names, settings)
      names.map { Process.handler(name, settings) }
    end

    def call(infile, outfile, emit: nil, processes: EMPTY_ARRAY, settings: EMPTY_HASH) # rubocop:disable Metrics/AbcSize
      settings   = Settings.new settings

      reader     = reader(extname!(infile), settings.for(:read))
      writer     = writer(extname!(outfile), settings.for(:write))
      emitter    = emitter(emit, settings.for(:emit)) if emit
      processors = processors(processes, settings.for(:process))

      new(Content.(infile)).tap do |instance|
        File.write outfile, instance.(reader: reader, writer: writer, emitter: emitter, processors: processors)
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

    def extname!(file)
      ext = File.extname.strip.downcase[1..]
      raise Error, "File extension missing: #{file}" unless ext
    end

    def emit_setup(kwargs, nbank, emit = :random)
      kwargs[:emit] = emit
      (kwargs[:setting][:emit] ||= {})[:nbank] = nbank
      kwargs.freeze
    end
  end
end
