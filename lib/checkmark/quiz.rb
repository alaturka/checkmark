# frozen_string_literal: true

class Checkmark
  # TODO: Move to support?

  File = Struct.new :path, :type, keyword_init: true do
    def content
      @content ||= path ? File.read(path) : $stdin.read
    end

    alias_method :origin, :path
  end

  def self.file!(path:, type:)
    raise Error, "No such file: #{path}" if path && !::File.exist?(path)

    File.new(path: path, type: type)
  end

  # TODO: Improve interface

  class Quiz
    attr_reader :content, :file, :settings

    def initialize(content, file, **settings)
      @content = content
      @file = file
      @settings = settings
    end

    def self.from_file(path:, type:, settings:)
      file = Checkmark.file!(path: path, type: type)
      new(file.content, file, **settings)
    end
  end
end
