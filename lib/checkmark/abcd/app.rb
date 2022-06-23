# frozen_string_literal: true

require 'combine_pdf'

class Checkmark
  class << self
    # rubocop:disable Naming/MethodName
    def ABCD(...)
      ABCD.(4, ...)
    end

    def AB(...)
      ABCD.(2, ...)
    end

    def A(...)
      ABCD.(1, ...)
    end
    # rubocop:enable Naming/MethodName
  end

  module ABCD
    DEFAULTS = {
      nout:   4,
      series: 'A'
    }.freeze

    class << self
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
