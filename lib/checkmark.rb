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

  def initialize(source, read:, process: [], settings: {})
    @source   = source
    @read     = read
    @process  = process
    @settings = settings

    @bank     = load
  end

  def call(write:, emit: nil)
    Write.handle(write) { |writer| writer.(Emit.handle(emit) { |emitter| emitter.(bank) }) }
  end

  private

  def load
    Read.handle(read) { |reader| reader.(source) } # FIXME: processors
  end

  class << self
    def call(infile, outfile, emit: nil, process: [], settings: {})
      read, write = Read.handler_name_for!(infile), Write.handler_name_for!(outfile)

      new(Content.(infile), read: read, process: process, settings: settings).tap do |instance|
        result = instance.(write: write, emit: emit)
        File.write(outfile, result)
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
