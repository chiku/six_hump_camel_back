require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/population", __FILE__)

describe "Population" do
  describe "the first vector" do
    it "is accessible" do
      constraints = [Constraint.new(min: 1, max: 1), Constraint.new(min: 2, max: 2)]
      vector = Vector.new(constraints, lambda {|i, j| i + j})
      population = Population.new(1, constraints, [1, 2], [1, 2], lambda {|i, j| i + j})
      assert_equal(vector, population[0])
    end
  end

  describe "with one vector" do
    it "has a fitness" do
      constraints = [Constraint.new(min: 1.1, max: 1.1), Constraint.new(min: 2.2, max: 2.2)]
      population = Population.new(1, constraints, [1.1, 2.2], [1.1, 2.2], lambda {|i, j| i + j})
      assert_in_delta(3.3, population[0].fitness, 0.00001)
    end
  end

  it "has a difference vector" do
    constraints = [Constraint.new(min: 1.0, max: 1.0)]
    population = Population.new(3, constraints, [1.0], [1.0], lambda {|i| i + 2})
    assert(population.difference_vector[0], 1.0)
  end

  it "has a crossover vector" do
    constraints = [Constraint.new(min: 1.0, max: 1.0)]
    population = Population.new(3, constraints, [1.0], [1.0], lambda {|i| i + 2})
    assert(population.crossover_vector[0], 1.0)
  end

  describe "with fitness criteria x squared plus one" do
    it "has a minima at zero" do
      constraints = [Constraint.new(min: -100, max: 100)]
      population = Population.new(100, constraints, [-100], [100], lambda {|x|  x*x+1  })
      vector, value, generations = population.differential_evolution(200000, 0.0005)

      assert_in_delta(value, 1.0, 0.0005);
      assert_in_delta(vector[0], 0.0, 0.002)
    end
  end

  describe "for camel hump back problem" do
    it "has a solution" do
      skip "don't run end-to-end test as a part of unit test suite"
      constraints = [Constraint.new(min: -3.0, max: 3.0), Constraint.new(min: -2.0, max: 2.0)]
      population = Population.new(100, constraints, [-3.0, -2.0], [3.0, 2.0], lambda {|x, y|  ( 4.0 - 2.1*x*x +  x*x*x*x/3.0) * x*x + x*y + ( -4.0  +  4.0*y*y) * y*y })
      vector, value, generations = population.differential_evolution(200000, 0.0)

      print "\nThe solution vector is: \t", vector[0], "\t", vector[1], "\n"
      print "\nThe answer is:\t", value, "\n"
      print "\nGenerations run:\t",generations, "\n"

      assert_in_delta(value, - 1.0316, 0.0005);
      assert((vector[0] + 0.0898).abs < 0.0005 && (vector[1] - 0.7126).abs < 0.0005 || (vector[0] - 0.0898).abs < 0.0005 && (vector[1] + 0.7126).abs < 0.0005)
    end
  end
end
