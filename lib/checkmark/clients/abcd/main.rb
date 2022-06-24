# frozen_string_literal: true

require 'combine_pdf'

class Checkmark
  module ABCD
    DEFAULTS = {
      nout:   4,
      series: 'A'
    }.freeze

    class << self
      def call(infile, outfile = nil, **kwargs) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        settings = Settings.new kwargs.merge DEFAULTS

        instance = Checkmark.read(infile, settings)
        name     = settings[:series]
        answers  = {}

        pdf      = CombinePDF.new

        settings[:nout].times do
          instance
            .processes(settings[:processors] || [])
            .write(:tex)
            .emit(:random).tap { |this| answers[name] = this.answers }
            .publish(:pdf, pdf, name: name.succ!)
        end

        Publish::PDF.answers(answers, pdf)

        pdf.save outfile
      end
    end
  end
end
