# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
end

RuboCop::RakeTask.new(:lint)

task default: %i[test]
