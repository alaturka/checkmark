# frozen_string_literal: true

class Checkmark
  class Quiz
    include ForwardableArray.(:@contents)

    attr_reader :contents, :settings

    def initialize(*contents, **settings)
      @contents = contents
      @settings = settings
    end

    def self.from_files(handler, *paths, **settings)
      new(*paths.map { Content.read(handler, _1) }, **settings)
    end
  end
end
