#!/usr/bin/env ruby

require File.expand_path("../lib/population", __FILE__)

def camel_hump_back_problem
  population = Population.new(50, 2, [-3.0, -2.0], [3.0, 2.0], lambda {|x, y|  ( 4.0 - 2.1*x*x +  x*x*x*x/3.0) * x*x + x*y + ( -4.0  +  4.0*y*y) * y*y })
  vector, value, generations = population.differential_evolution(200000, 0.000001)

  print "\n\nThe solution vector is: \t", vector[0], "\t", vector[1]
  print "\nThe answer is:\t", value
  print "\nGenerations run:\t",generations
end

camel_hump_back_problem
