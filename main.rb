#!/usr/bin/env ruby

require File.expand_path("../lib/population", __FILE__)

def camel_hump_back_problem
  constraints = [Constraint.new(min: -3.0, max: 3.0), Constraint.new(min: -2.0, max: 2.0)]
  vectors     = 50.times.map { Vector.new(constraints.map(&:random)) }
  population  = Population.new(vectors, lambda {|x, y|  ( 4.0 - 2.1*x*x +  x*x*x*x/3.0) * x*x + x*y + ( -4.0  +  4.0*y*y) * y*y })

  vector, value, generations = population.differential_evolution(200000, 0.000001)

  puts "\n\nThe solution vector is: \t", vector[0], "\t", vector[1]
  puts "\nThe answer is:\t", value
  puts "\nGenerations run:\t",generations
end

camel_hump_back_problem
