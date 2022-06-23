# frozen_string_literal: true

require_relative 'checkmark/support'
require_relative 'checkmark/error'
require_relative 'checkmark/version'

require_relative 'checkmark/emit'
require_relative 'checkmark/model'
require_relative 'checkmark/process'
require_relative 'checkmark/publish'
require_relative 'checkmark/read'
require_relative 'checkmark/write'

class Checkmark
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def call(reader:, writer:, processors: EMPTY_ARRAY, emitter: nil)
    write(emit(process(read(source, reader), processors), emitter, writer), writer)
  end

  def read(source, reader)
    reader.(source)
  end

  def process(bank, processors)
    bank.tap { processors.each { |processor| processor.(bank) } }
  end

  def emit(bank, emitter, publisher = nil)
    emitter ? emitter.(bank, publisher) : [bank]
  end

  def write(bank, writer)
    writer.(bank)
  end

  def publish(bank, publisher)
    publisher.(bank)
  end

  class << self
    { reader: Read, processor: Process, emitter: Emit, writer: Write, publisher: Publish }.each do |extension, modul|
      define_method(extension) { |name, settings| modul.handler!(name, settings) }
    end

    def processors(names, settings)
      names.map { Process.handler(name, settings) }
    end

    def call(infile, outfile, emit: nil, processes: EMPTY_ARRAY, settings: EMPTY_HASH) # rubocop:disable Metrics/AbcSize
      settings   = Settings.new settings

      publisher  = publisher(extname!(outfile), settings.for(:publish))
      reader     = reader(extname!(infile), settings.for(:read))
      writer     = writer(publisher.favour, settings.for(:write))
      emitter    = emitter(emit, settings.for(:emit)) if emit
      processors = processors(processes, settings.for(:process))

      new(Content.(infile)).tap do |instance|
        publisher.(instance.(reader: reader, writer: writer, emitter: emitter, processors: processors), outfile)
      end
    end
  end
end
