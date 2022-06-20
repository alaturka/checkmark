# frozen_string_literal: true

require 'optparse'

require 'checkmark'

class Checkmark
  module CLI
    def self.call(*argv, **kwargs)
      options = {}.merge(kwargs)
      args setup(argv, options), argv

      Checkmark.(content, type: stype)
    rescue OptionParser::InvalidOption, Error => e
      abort(e.message)
    end

    class << self
      private

      # rubocop:disable Metrics/MethodLength
      # codebeat:disable[LOC]
      def setup(argv, _options)
        Signal.trap('INT') { Kernel.abort '' }

        OptionParser.new do |option|
          program_name = option.program_name
          option.banner = <<~BANNER
            Usage: #{program_name} [options...] <FILE>

            See #{program_name}(1) manual page for detailed help.

            Options:

          BANNER

          option.on_tail('-h', '--help', 'Show this message') do
            abort option.help
          end

          option.on_tail('-v', '--version', 'Show version') do
            warn VERSION
            exit
          end
        end.tap { |parser| parser.parse!(argv) } # rubocop:disable Style/MultilineBlockChain
      end
      # codebeat:enable[LOC]
      # rubocop:enable Metrics/MethodLength

      def args(parser, argv)
        if argv.empty?
          warn parser.help
          warn ''
          abort 'Error: TODO'
        end

        return if argv.size <= 1

        warn parser.help
        warn ''
        abort 'Error: Too many arguments.'
      end
    end
  end
end
