require "test/unit"
require "./population"

class PopulationTest < Test::Unit::TestCase
  def test_first_vector_in_population_one_can_be_accessed
    vector = Vector.new(2, [1, 2], [1, 2], lambda {|i, j| i + j})
    population = Population.new(1, 2, [1, 2], [1, 2], lambda {|i, j| i + j})
    assert_equal(vector, population[0])        
  end

  def test_population_with_one_vector_has_one_proper_fitness
    population = Population.new(1, 2, [1.1, 2.2], [1.1, 2.2], lambda {|i, j| i + j})
    assert_in_delta(3.3, population[0].fitness, 0.00001)
  end

  def test_can_properly_find_difference_vector
    population = Population.new(3, 1, [1.0], [1.0], lambda {|i| i + 2})
    assert(population.difference_vector[0], 1.0)
  end

  def test_can_properly_find_crossover_vector
    population = Population.new(3, 1, [1.0], [1.0], lambda {|i| i + 2})
    assert(population.crossover_vector[0], 1.0)
  end

  def test_x_squared_plus_one_has_minima_one_at_zero
    population = Population.new(100, 1, [-100], [100], lambda {|x|  x*x+1  })
    vector, value, generations = population.differential_evolution(200000, 0.0005)

    assert_in_delta(value, 1.0, 0.0005);
    assert_in_delta(vector[0], 0.0, 0.0005)
  end

  def test_camel_hump_back_problem
    population = Population.new(100, 2, [-3.0, -2.0], [3.0, 2.0], lambda {|x, y|  ( 4.0 - 2.1*x*x +  x*x*x*x/3.0) * x*x + x*y + ( -4.0  +  4.0*y*y) * y*y })
    vector, value, generations = population.differential_evolution(200000, 0.0)

    print "\nThe solution vector is: \t", vector[0], "\t", vector[1], "\n"
    print "\nThe answer is:\t", value, "\n"
    print "\nGenerations run:\t",generations, "\n"

    assert_in_delta(value, - 1.0316, 0.0005);
    assert((vector[0] + 0.0898).abs < 0.0005 && (vector[1] - 0.7126).abs < 0.0005 || (vector[0] - 0.0898).abs < 0.0005 && (vector[1] + 0.7126).abs < 0.0005)
  end
end