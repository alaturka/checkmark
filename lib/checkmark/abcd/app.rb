# frozen_string_literal: true

require 'combine_pdf'

class Checkmark
  module ABCD
    class << self
      # rubocop:disable Naming/MethodName
      def ABCD(...)
        abcd(4, ...)
      end

      def AB(...)
        abcd(2, ...)
      end

      def A(...)
        abcd(1, ...)
      end
      # rubocop:enable Naming/MethodName

      ABCD_DEFAULTS = {
        nout:   4,
        series: 'A'
      }.freeze

      def call(infile, outfile = nil, **kwargs)
        settings = Settings.new kwargs.merge ABCD_DEFAULTS

        pdf      = CombinePDF.new
        name     = settings[:series]

        settings[:nout].times do
          call(infile, processes: processes, settings: settings)
          name.succ!
        end

        pdf.save outfile
      end
    end

    private

    def build
      nil
    end
  end
end
