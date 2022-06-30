# frozen_string_literal: true

require "rake/clean"

require "rubocop/rake_task"

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ["--display-cop-names"]
end

desc "Lint code"
task lint: :rubocop

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs.push("test")
  t.test_files = FileList["test/**/*_test.rb"]
end

require "rubygems/tasks"
Gem::Tasks.new(console: false) do |tasks|
  tasks.push.host = ENV.fetch("RUBYGEMS_HOST") { Gem::DEFAULT_HOST }
end

CLEAN.include("*.gem", "pkg")

task default: [:lint, :test]
