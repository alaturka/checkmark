# frozen_string_literal: true

module Checkmark
  module CLI
    module Commands
      class Compile < Dry::CLI::Command
        desc 'Compile quiz'

        def call(*)
          puts 'Compile'
        end
      end
    end
  end
end
