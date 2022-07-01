# frozen_string_literal: true

module Checkmark
  module ABCD
    DEFAULTS = {
      nout:   4,
      series: "A",
    }.freeze

    class << self
      def call(infile, outfile = nil, **kwargs)
        settings = Settings.new(kwargs.merge(DEFAULTS))

        instance = Checkmark::Runner.read(infile, settings)
        name     = settings[:series]
        answers  = {}

        pdf      = PDF.new

        settings[:nout].times do
          instance
            .processes(settings[:processors])
            .render(:tex)
            .emit(:random).tap { answers[name] = _1.bank.answers }
            .publish(:pdf, pdf, name: name.succ!)
        end

        Publish::PDF.supplimentary(pdf, answers: answers)

        pdf.save(outfile)
      end
    end
  end
end
