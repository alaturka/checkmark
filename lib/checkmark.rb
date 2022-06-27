# frozen_string_literal: true

require_relative 'checkmark/support'
require_relative 'checkmark/errors'
require_relative 'checkmark/version'

require_relative 'checkmark/objects'
require_relative 'checkmark/methods'
require_relative 'checkmark/loaders'

class Checkmark
  attr_reader :bank, :settings

  def initialize(bank = Bank.new, **settings)
    @bank     = bank
    @settings = settings
  end

  def read(reader, ...)
    self.class.new Read.handler!(reader, settings.for(:read)).(...), **settings
  end

  { process: Process, emit: Emit, write: Write, publish: Publish }.each do |method, modul|
    define_method(method) do |name, *args, **kwargs|
      return self unless name

      self.class.new modul.handler!(name, settings.for(method)).(bank, *args, **kwargs), **settings
    end
  end

  def processes(processors, ...)
    (result = self).tap { (processors || []).each { result = result.process(_1, ...) } }
  end

  def emitn(nbanks, emitter, ...)
    return [self] if !nbanks || nbanks.zero?

    Array.new(nbanks).map { emit(emitter, ...) }
  end

  def to_json(...)
    raise NotImplementedError
  end

  def self.call(source, reader, settings, ...)
    new(**settings).read(reader, source, ...).tap { yield(_1) if block_given? }
  end

  def self.load(file, settings, ...)
    call(Content.(File.read(file), Support.extname!(file).to_sym, origin: file), settings, ...)
  end
end
