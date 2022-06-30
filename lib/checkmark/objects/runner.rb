# frozen_string_literal: true

module Checkmark
  class Runner
    attr_reader :bank, :settings

    def initialize(bank = Bank.new, **settings)
      @bank     = bank
      @settings = settings
    end

    def parse(parser, ...)
      self.class.new(Parse.handler!(parser, settings.for(:read)).(...), **settings)
    end

    { process: Process, emit: Emit, render: Render, publish: Publish }.each do |method, modul|
      define_method(method) do |name, *args, **kwargs|
        return self unless name

        self.class.new(modul.handler!(name, settings.for(method)).(bank, *args, **kwargs), **settings)
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

    def self.call(source, parser, settings, ...)
      new(**settings).parse(parser, source, ...).tap { yield(_1) if block_given? }
    end

    def self.read(file, settings, ...)
      call(Content.(File.read(file), Support.extname!(file).to_sym, origin: file), settings, ...)
    end
  end
end
