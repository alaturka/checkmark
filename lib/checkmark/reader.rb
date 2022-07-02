# frozen_string_literal: true

module Checkmark
  class Reader
    extend Queryable

    attr_reader :content, :parser, :settings

    def initialize(content, parser, **settings)
      @content  = content
      @parser   = parser
      @settings = settings
    end

    def self.load_file(file, parser = nil, **settings)
      content = Content.(File.read(file), Support.extname!(file).to_sym, origin: file)
      new(content, parser, **settings)
    end

    require_relative "reader/parse"

    require_relative "reader/many"
    require_relative "reader/one"
    require_relative "reader/refs"
  end
end
