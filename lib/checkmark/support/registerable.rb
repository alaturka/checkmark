# frozen_string_literal: true

module Checkmark
  class Registerable < Module
    attr_reader :consumer

    def initialize(consumer)
      super()

      @consumer = consumer

      @consumer.instance_variable_set(:@registery, {})
      @consumer.extend(ConsumerMethods)
    end

    def extended(base)
      raise "Method 'registery' already defined in #{base}" if base.respond_to?(:registery)

      registery = consumer.instance_variable_get(:@registery)
      base.define_singleton_method(:registery) { registery }

      base.extend(ClassMethods)
    end

    def self.[](...)
      new(...)
    end

    module ClassMethods
      def register(symbol, klass = nil)
        registery[type = symbol.to_sym] = klass || self
        singleton_class.attr_reader(:type)
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
        raise Error, "Not a registered type: #{type}" unless registery.key?(type = type.to_sym)

        registery[type].new(...)
      end

      def handler_for_file!(file, ...)
        type = Support.extname(file)
        return registery[type].new(...) if registery.key?(type)

        raise Error, "Couldn't find a handler for #{file}"
      end
    end
  end
end
