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

  class Registerable < Module
    attr_reader :consumer

    def initialize(consumer)
      super()

      @consumer = consumer

      @consumer.instance_variable_set(:@registery, {})
      @consumer.singleton_class.attr_reader :registery

      @consumer.extend ConsumerMethods
    end

    def extended(base)
      registery = consumer.registery
      base.define_singleton_method(:registery) { registery }

      base.extend ClassMethods
    end

    def self.[](...)
      new(...)
    end

    module ClassMethods
      def register(symbol, klass = nil)
        registery[symbol.to_sym] = klass || self
      end
    end

    module ConsumerMethods
      def available?(key)
        registery.key?(key)
      end

      def availables
        registery.keys
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
