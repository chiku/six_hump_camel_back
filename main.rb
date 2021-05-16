#!/usr/bin/env ruby
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'six_hump_camel_back'

constraints = [SixHumpCamelBack::Constraint.new(min: -3.0, max: 3.0), SixHumpCamelBack::Constraint.new(min: -2.0, max: 2.0)]
vectors     = 50.times.map { SixHumpCamelBack::Vector.new(constraints.map(&:random)) }
population  = SixHumpCamelBack::Population.new(
  vectors,
  lambda { |x, y|
    (4.0 - 2.1 * x * x + x * x * x * x / 3.0) * x * x + x * y + (-4.0 + 4.0 * y * y) * y * y
  }
)

vector, value, generations = population.differential_evolution(200_000, 0.000001)

puts "\n\nThe solution vector is: \t", vector[0], "\t", vector[1]
puts "\nThe answer is:\t", value
puts "\nGenerations run:\t", generations
