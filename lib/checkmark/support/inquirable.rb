# frozen_string_literal: true

module Checkmark
  module Inquirable
    def _lookup
      @_lookup ||= Hash[
        *subclasses.map { |klass| [klass.name.split("::").last.downcase.to_sym, klass] }.flatten
      ]
    end

    def [](name)
      _lookup[name.to_sym].tap { raise "No such subclass exist for #{name}" unless _1 }
    end

    def each_subclass(...)
      _lookup.each(...)
    end

    def availables
      _lookup.keys
    end

    def available?(name)
      _lookup.key?(name.to_sym)
    end

    def instance_for(name, ...)
      self[name].new(...)
    end

    def instance_for_file(file, ...)
      instance_for(File.extname(file).strip.downcase[1..], ...)
    end
  end
end
