# frozen_string_literal: true

module Checkmark
  class Reader
    attr_reader :content, :parser, :settings

    def initialize(content, parser, **settings)
      @content  = content
      @parser   = parser
      @settings = settings
    end

    def self.load_file(file, parser = nil, **settings)
      content = Content.(File.read(file), Support.extname!(file).to_sym, origin: file)
      new content, parser, **settings
    end

    require_relative 'readers/many'
    require_relative 'readers/one'
    require_relative 'readers/refs'
  end
end
