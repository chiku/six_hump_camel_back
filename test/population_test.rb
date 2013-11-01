require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/population", __FILE__)

describe "Population" do
  let(:constraint_1_to_2) { Constraint.new(min: 1, max: 2).with_constant_randomization(0.5) }
  let(:constraint_minus1_to_1) { Constraint.new(min: -1, max: 1).with_constant_randomization(0.5) }
  let(:constraints) { [constraint_1_to_2, constraint_minus1_to_1] }
  let(:add_two) { ->(i, j) { i + j } }
  let(:population) { Population.new(3, constraints, add_two) }

  describe "#[]" do
    it "is a vector at the given position" do
      population[0].must_equal Vector.new(constraints)
    end
  end

  describe "#difference_vector" do
    it "is a vector around the target separated by a difference between second and third vectors" do
      population = Population.new(3, constraints, add_two)
      assert(population.difference_vector[0], 1.0)
    end
  end

  it "has a crossover vector" do
    constraints = [Constraint.new(min: 1.0, max: 1.0)]
    population = Population.new(3, constraints, lambda {|i| i + 2})
    assert(population.crossover_vector[0], 1.0)
  end

  describe "with fitness criteria x squared plus one" do
    it "has a minima at zero" do
      constraints = [Constraint.new(min: -100, max: 100)]
      population = Population.new(100, constraints, lambda {|x|  x*x+1  })
      vector, value, generations = population.differential_evolution(200000, 0.0005)

      assert_in_delta(value, 1.0, 0.0005);
      assert_in_delta(vector[0], 0.0, 0.002)
    end
  end

  describe "for camel hump back problem" do
    it "has a solution" do
      skip "don't run end-to-end test as a part of unit test suite"
      constraints = [Constraint.new(min: -3.0, max: 3.0), Constraint.new(min: -2.0, max: 2.0)]
      population = Population.new(100, constraints, lambda {|x, y|  ( 4.0 - 2.1*x*x +  x*x*x*x/3.0) * x*x + x*y + ( -4.0  +  4.0*y*y) * y*y })
      vector, value, generations = population.differential_evolution(200000, 0.0)

      print "\nThe solution vector is: \t", vector[0], "\t", vector[1], "\n"
      print "\nThe answer is:\t", value, "\n"
      print "\nGenerations run:\t",generations, "\n"

      assert_in_delta(value, - 1.0316, 0.0005);
      assert((vector[0] + 0.0898).abs < 0.0005 && (vector[1] - 0.7126).abs < 0.0005 || (vector[0] - 0.0898).abs < 0.0005 && (vector[1] + 0.7126).abs < 0.0005)
    end
  end
end
