# frozen_string_literal: true

require "open3"

module Checkmark
  module Command
    Result = Struct.new(:argv, :out, :err, :status, :canceled, keyword_init: true) do
      def exitcode
        @exitcode ||= status&.exitstatus || 128
      end

      def ok?
        exitcode.zero?
      end

      def notok?
        !ok?
      end

      def timeout?
        Signal.signame(status&.termsig || 0) == 'XCPU'
      end

      def canceled?
        canceled
      end

      def segfaulted?
        Signal.signame(status&.termsig || 0) == 'SEGV'
      end

      def command
        @command ||= argv[(argv.first.is_a?(::Hash) ? 1 : 0)..].join(" ")
      end

      def outs
        @outs ||= out.split("\n")
      end

      def errs
        @errs ||= err.split("\n")
      end
    end

    def self.run(*argv, **kwargs)
      canceled = false
      trap("INT") { canceled = true }

      out, err, status = Open3.capture3(*argv, **kwargs)

      Result.new(out: out, err: err, argv: argv, status: status, canceled: canceled)
    end

    # rubocop:disable Layout
    RLIMIT_SAFE = {                             # See https://stackoverflow.com/questions/38419570/setrlimit-in-ruby
      rlimit_cpu:   [15,                   16], # 15 seconds, +1 for hard limit to signal XCPU before reaching hard limit
      rlimit_as:    [536_870_912, 536_870_912], # 512 MB, half of the memory of a micro instance
      rlimit_data:  [536_870_912, 536_870_912], # 512 MB, half of the memory of a micro instance
      rlimit_core:  0                           # no core dump
    }.freeze
    # rubocop:enable Layout

    def self.run_limited(*argv, **kwargs)
      run(*argv, **RLIMIT_SAFE.merge(kwargs))
    end
  end
end
