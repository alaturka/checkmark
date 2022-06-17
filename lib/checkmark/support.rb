# frozen_string_literal: true

require 'forwardable'

module Checkmark
  class ForwardableArray < Module
    def initialize(forwardable, *extra_methods)
      super()

      @forwardable = forwardable
      @extra_methods = extra_methods
    end

    def included(base)
      base.extend Forwardable

      base.def_delegators(@forwardable, :<<, :append, :each, :map, *@extra_methods)

      base.include InstanceMethods
    end

    module InstanceMethods
      def add(array)
        append(*array)
      end
    end
  end
end
