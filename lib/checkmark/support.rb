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
    attr_reader :type, :path

    def initialize(type, path = nil)
      super(::String.new)

      @type = type.to_sym
      @path = path
    end

    def read
      replace (path ? File : $stdin).read
      self
    end

    def write
      path ? File.write(path, self) : puts(self)
      self
    end

    def self.read(type, path = nil)
      new(type, path).read
    end

    def self.write(type, path = nil)
      new(type, path).write
    end
  end
end
