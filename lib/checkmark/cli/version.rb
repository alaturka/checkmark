# frozen_string_literal: true

module Checkmark
  module CLI
    module Commands
      class Version < Dry::CLI::Command
        desc 'Print version'

        def call(*)
          puts VERSION
        end
      end
    end
  end
end
