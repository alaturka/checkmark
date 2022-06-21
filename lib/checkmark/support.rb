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
    attr_reader :origin

    def initialize(string = '', origin: nil)
      super(::String.new(string))

      @origin = origin
    end

    def self.read(file)
      new(File.read(file), origin: file)
    end

    def self.call(...)
      read(...)
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
        registery[type = symbol.to_sym] = klass || self
        singleton_class.attr_reader :type
        instance_variable_set(:@type, type)
      end
    end

    module ConsumerMethods
      def available?(key)
        registery.key?(key)
      end

      def availables
        registery.keys
      end

      def handler!(file)
        key = File.extname.strip.downcase[1..]
        raise Error, "No extension found for file: #{file}" unless key

        key = key.to_sym
        raise Error, "Unsupported file type: #{key}" unless registery.key?(key)

        registery[key]
      end
    end
  end
end
