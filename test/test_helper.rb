# frozen_string_literal: true

begin
  require('simplecov')
  SimpleCov.start do
    add_filter('/test/')
  end
rescue LoadError
  puts("\nPlease install simplecov to generate coverage report!\n\n")
end

require 'minitest/autorun'
require 'minitest/spec'
