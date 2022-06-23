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
  attr_reader :bank, :settings

  def initialize(bank = EMPTY_BANK, **settings)
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
    (result = self).tap { processors.each { result = result.process(_1, ...) } }
  end

  def nemit(nbanks, emitter, ...)
    Array.new(nbanks).map { emit(emitter, ...) }
  end

  def self.call(reader, source, settings, ...)
    new(**settings).read(reader, source, ...)
  end
end
