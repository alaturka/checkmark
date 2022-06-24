# frozen_string_literal: true

class Checkmark
  module Publish
    class PDF < Base
      register :pdf

      def call(bank, _outfile)
        accepted!(bank)
      end

      def accepts
        %i[tex]
      end
    end
  end
end
