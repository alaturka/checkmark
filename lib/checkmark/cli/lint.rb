# frozen_string_literal: true

module Checkmark
  module CLI
    module Commands
      class Lint < Dry::CLI::Command
        desc 'Lint quiz'

        def call(*)
          puts 'Lint'
        end
      end
    end
  end
end
