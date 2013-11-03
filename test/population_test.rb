require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/constraint", __FILE__)
require File.expand_path("../../lib/vector", __FILE__)
require File.expand_path("../../lib/population", __FILE__)

describe "Population" do
  let(:add_two) { ->(i, j) { i + j } }
  let(:population) { Population.new([Vector.new(1, 0), Vector.new(3, -1), Vector.new(1, 2)], add_two) }

  describe "#[]" do
    it "is a vector at the given position" do
      population[0].must_equal Vector.new(1, 0)
    end
  end

  describe "#[]=" do
    let(:new_vector) { Vector.new(2, 3) }
    before { population[0] = new_vector }

    it "sets a vector at the given position" do
      population[0].must_equal new_vector
    end
  end

  describe "#difference_vector" do
    it "is a vector around the target separated by a difference between second and third vectors" do
      population.difference_vector(factor: 0.5, v1: population[0], v2: population[1], v3: population[2]).must_equal Vector.new(2, -1.5)
    end
  end

  describe "#crossover_vector" do
    let(:cycle) { [0.2, 0.8].cycle }
    let(:randomization) { -> { cycle.next } }

    it "is a vector chosen from a target vector and another vector based on crossover factor" do
      target_vector = population[0]
      population.crossover_vector(target_vector, factor: 0.5, partner: population[1], randomization: randomization).must_equal Vector.new(3, 0)
    end
  end

  describe "#total_fitness" do
    it "is the sum of all fitnesses in the population" do
      population.total_fitness.must_equal 6
    end
  end

  describe "#best_vector" do
    it "has the minimum value for fitness function in the population" do
      population.best_vector.must_equal population[0]
    end
  end

  describe "#convergance" do
    it "is the difference of average fitness and best fitness" do
      population.convergance.must_equal 1
    end
  end

  describe "with fitness criteria x squared plus one" do
    it "has a minima at zero" do
      constraints = [Constraint.new(min: -100, max: 100)]
      vectors = 100.times.map { Vector.new(constraints.map(&:random)) }
      population = Population.new(vectors, lambda {|x| x * x + 1 })
      vector, value, generations = population.differential_evolution(200000, 0.0005)

      assert_in_delta(value, 1.0, 0.0005);
      assert_in_delta(vector[0], 0.0, 0.002)
    end
  end

  describe "for camel hump back problem" do
    it "has a solution" do
      skip "don't run end-to-end test as a part of unit test suite"
      constraints = [Constraint.new(min: -3.0, max: 3.0), Constraint.new(min: -2.0, max: 2.0)]
      vectors = 100.times.map { Vector.new(constraints.map(&:random)) }
      population = Population.new(vectors, lambda {|x, y|  ( 4.0 - 2.1*x*x +  x*x*x*x/3.0) * x*x + x*y + ( -4.0  +  4.0*y*y) * y*y })
      vector, value, generations = population.differential_evolution(200000, 0.0)

      print "\nThe solution vector is: \t", vector[0], "\t", vector[1], "\n"
      print "\nThe answer is:\t", value, "\n"
      print "\nGenerations run:\t",generations, "\n"

      assert_in_delta(value, - 1.0316, 0.0005);
      assert((vector[0] + 0.0898).abs < 0.0005 && (vector[1] - 0.7126).abs < 0.0005 || (vector[0] - 0.0898).abs < 0.0005 && (vector[1] + 0.7126).abs < 0.0005)
    end
  end
end
