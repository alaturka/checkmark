# frozen_string_literal: true

class Checkmark
  EMPTY_ARRAY = [].freeze
  EMPTY_HASH = {}.freeze

  module Support
    module_function

    def extname!(file)
      ext = File.extname.strip.downcase[1..]
      raise Error, "File extension missing: #{file}" unless ext
    end
  end
end
