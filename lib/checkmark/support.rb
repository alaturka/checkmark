# frozen_string_literal: true

require 'delegate'
require 'forwardable'

class Checkmark
  EMPTY_ARRAY = [].freeze
  EMPTY_HASH = {}.freeze

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

  class Settings < DelegateClass(::Hash)
    def for(section)
      self[section.to_sym] || EMPTY_HASH
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
      def available?(type)
        registery.key?(type.to_sym)
      end

      def availables
        registery.keys
      end

      def handler!(type, ...)
        raise Error, "No extension found: #{type}" unless registery.key?(type = type.to_sym)

        registery[type].new(...)
      end
    end
  end

  class Extension
    def self.[](modul, &block)
      Class.new(self, &block).tap { |klass| klass.extend Registerable[modul] }
    end

    attr_reader :settings

    def initialize(settings)
      @settings = settings.dup.freeze
    end

    def call(...)
      raise NotImplementedError
    end
  end

  module Support
    module_function

    def extname!(file)
      ext = File.extname.strip.downcase[1..]
      raise Error, "File extension missing: #{file}" unless ext
    end
  end
end
