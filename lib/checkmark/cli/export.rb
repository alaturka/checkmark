# frozen_string_literal: true

module Checkmark
  module CLI
    module Commands
      class Export < Dry::CLI::Command
        desc 'Export quiz'

        def call(*)
          puts 'Export'
        end
      end
    end
  end
end
