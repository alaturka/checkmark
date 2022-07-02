# frozen_string_literal: true

module Checkmark
  module Queryable
    def _subclasses_lookup
      @_subclasses_lookup ||= Hash[
        *subclasses.map { |klass| [klass.name.split("::").last.downcase.to_sym, klass] }.flatten
      ]
    end

    def [](name)
      _subclasses_lookup[name.to_sym].tap { raise "No such subclass exist for #{name}" unless _1 }
    end

    def each_name_class(...)
      _subclasses_lookup.each(...)
    end

    def availables
      _subclasses_lookup.keys
    end

    def available?(name)
      _subclasses_lookup.key?(name.to_sym)
    end

    def instance_for(name, ...)
      self[name].new(...)
    end

    def instance_for_file(file, ...)
      instance_for(File.extname(file).strip.downcase[1..], ...)
    end
  end
end
