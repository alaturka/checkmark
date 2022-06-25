# frozen_string_literal: true

class Checkmark
  EMPTY_ARRAY = [].freeze
  EMPTY_HASH  = {}.freeze

  module Support
    module_function

    def extname(file)
      File.extname(file).strip.downcase[1..]
    end

    def extname!(file)
      extname(file).tap { raise Error, "File extension missing: #{file}" unless _1 }
    end
  end
end
