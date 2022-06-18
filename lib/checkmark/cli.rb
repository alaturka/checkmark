# frozen_string_literal: true

require 'checkmark'

require 'dry/cli'

module Checkmark
  module CLI
    module Commands
      extend Dry::CLI::Registry

      Dir[File.join(__dir__, 'cli/*.rb')].each { |command| require command }

      register 'version', Version, aliases: ['v', '-v', '--version']
    end
  end
end
