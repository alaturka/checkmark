# frozen_string_literal: true

require 'open3'

module Checkmark
  module Command
    Result = Struct.new :argv, :out, :err, :status, :canceled, keyword_init: true do
      def exitcode
        @exitcode ||= status&.exitstatus || 128
      end

      def ok?
        exitcode.zero?
      end

      def notok?
        !ok?
      end

      def canceled?
        canceled
      end

      def command
        @command ||= argv[(argv.first.is_a?(::Hash) ? 1 : 0)..].join(' ')
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
      trap('INT') { canceled = true }

      out, err, status = Open3.capture3(*argv, **kwargs)

      Result.new out: out, err: err, argv: argv, status: status, canceled: canceled
    end
  end
end
