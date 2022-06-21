# frozen_string_literal: true

require 'delegate'
require 'forwardable'

class Checkmark
  class ForwardableArray < Module
    def initialize(forwardable, *extra_methods)
      super()

      @forwardable = forwardable
      @extra_methods = extra_methods
    end

    def included(base)
      base.extend Forwardable
      base.def_delegators(@forwardable, :<<, :append, :each, :map, :size, *@extra_methods)
      base.include InstanceMethods
    end

    def self.call(...)
      new(...)
    end

    module InstanceMethods
      def add(array)
        append(*array)
      end
    end
  end

  class Content < DelegateClass(::String)
    attr_reader :handler, :path

    def initialize(handler, path = nil)
      super(::String.new)

      @handler = handler.to_sym
      @path = path
    end

    def type
      handler.type
    end

    def handle(...)
      handler.(self, ...)
    end

    def read
      replace (path ? File : $stdin).read
      self
    end

    def write
      path ? File.write(path, self) : puts(self)
      self
    end

    def self.read(handler, path = nil)
      new(handler, path).read
    end

    def self.write(handler, path = nil)
      new(handler, path).write
    end
  end
end
