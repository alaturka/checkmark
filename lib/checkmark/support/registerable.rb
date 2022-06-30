# frozen_string_literal: true

module Checkmark
  class Registerable < Module
    attr_reader :consumer

    def initialize(consumer)
      super()

      @consumer = consumer

      @consumer.instance_variable_set(:@registery, {})
      @consumer.singleton_class.attr_reader(:registery)

      @consumer.extend(ConsumerMethods)
    end

    def extended(base)
      registery = consumer.registery
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
    end
  end
end
