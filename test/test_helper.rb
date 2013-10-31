begin
  require 'simplecov'
  SimpleCov.command_name 'Unit Tests'
  SimpleCov.start do
    add_filter "/test/"
  end
rescue LoadError
  puts "\nPlease install simplecov to generate coverage report!\n\n"
end

require "minitest/autorun"
# require "minitest/spec"
require "minitest/reporters"

MiniTest::Reporters.use! [MiniTest::Reporters::SpecReporter.new]
