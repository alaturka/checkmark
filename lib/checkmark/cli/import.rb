# frozen_string_literal: true

module Checkmark
  module CLI
    module Commands
      class Import < Dry::CLI::Command
        desc 'Import quiz'

        def call(*)
          puts 'Import'
        end
      end
    end
  end
end
