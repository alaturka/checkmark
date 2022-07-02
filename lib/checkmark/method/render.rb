# frozen_string_literal: true

module Checkmark
  class Method
    class Render < self
      require_relative "render/html"
      require_relative "render/sil"
      require_relative "render/tex"
    end
  end
end
