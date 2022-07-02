# frozen_string_literal: true

module Checkmark
  EMPTY_ARRAY = [].freeze
  EMPTY_HASH  = {}.freeze

  module Support
    extend self

    def extname(file)
      File.extname(file).strip.downcase[1..]
    end

    def extname!(file)
      extname(file).tap { raise Error, "File extension missing: #{file}" unless _1 }
    end
  end

  module RubyFeatures # :nodoc:
    CLASS_SUBCLASSES = Class.method_defined?(:subclasses) # RUBY_VERSION >= "3.1"
  end
end

# Innocent monkey patchings stolen from ActiveSupport as a polyfill for some Ruby >= 3.1 features

class Class
  if Checkmark::RubyFeatures::CLASS_SUBCLASSES
    # Returns an array with all classes that are < than its receiver.
    #
    #   class C; end
    #   C.descendants # => []
    #
    #   class B < C; end
    #   C.descendants # => [B]
    #
    #   class A < B; end
    #   C.descendants # => [B, A]
    #
    #   class D < C; end
    #   C.descendants # => [B, A, D]
    def descendants
      subclasses.concat(subclasses.flat_map(&:descendants))
    end
  else
    def descendants
      ObjectSpace.each_object(singleton_class).reject do |k|
        k.singleton_class? || k == self
      end
    end
  end

  # Returns an array with the direct children of +self+.
  #
  #   class Foo; end
  #   class Bar < Foo; end
  #   class Baz < Bar; end
  #
  #   Foo.subclasses # => [Bar]
  def subclasses
    descendants.select { |descendant| descendant.superclass == self }
  end unless Checkmark::RubyFeatures::CLASS_SUBCLASSES
end
