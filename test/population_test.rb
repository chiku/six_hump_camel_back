require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/constraint", __FILE__)
require File.expand_path("../../lib/vector", __FILE__)
require File.expand_path("../../lib/cached_vector", __FILE__)
require File.expand_path("../../lib/cached_vectors", __FILE__)
require File.expand_path("../../lib/population", __FILE__)

describe "Population" do
  let(:add_two) { ->(i, j) { i + j } }
  let(:cacher) { CacheCreator.new(add_two) }
  let(:population) { Population.new([Vector.new(1, 0), Vector.new(3, -1), Vector.new(1, 2)], add_two) }

  describe "#difference_vector" do
    it "is a vector around the target separated by a difference between second and third vectors" do
      population.difference_vector(factor: 0.5, v1: population[0], v2: population[1], v3: population[2]).must_equal cacher.cache(Vector.new(2, -1.5))
    end
  end

  describe "#crossover_vector" do
    let(:cycle) { [0.2, 0.8].cycle }
    let(:randomization) { -> { cycle.next } }

    it "is a vector chosen from a target vector and another vector based on crossover factor" do
      population.crossover_vector(target: population[0], factor: 0.5, partner: population[1], randomization: randomization).must_equal cacher.cache(Vector.new(3, 0))
    end
  end

  describe "with fitness criteria x squared plus one" do
    it "has a minima at zero" do
      constraints = [Constraint.new(min: -100, max: 100)]
      vectors = 100.times.map { Vector.new(constraints.map(&:random)) }
      population = Population.new(vectors, lambda {|x| x * x + 1 })
      vector, value, generations, convergance = population.differential_evolution(200000, 0.00005)

      assert_in_delta(value, 1.0, 0.0005);
      assert_in_delta(vector[0], 0.0, 0.008)
    end
  end

  describe "for camel hump back problem" do
    it "has a solution" do
      constraints = [Constraint.new(min: -3.0, max: 3.0), Constraint.new(min: -2.0, max: 2.0)]
      vectors = 100.times.map { Vector.new(constraints.map(&:random)) }
      population = Population.new(vectors, lambda {|x, y|  ( 4.0 - 2.1*x*x +  x*x*x*x/3.0) * x*x + x*y + ( -4.0  +  4.0*y*y) * y*y })
      vector, value, generations, convergance = population.differential_evolution(200000, 0.00005)

      puts "The solution vector is: #{vector[0]}, #{vector[1]}"
      puts "The answer is: #{value}"
      puts "Generations run: #{generations}"
      puts "Convergance: #{convergance}"

      assert_in_delta(value, - 1.0316, 0.0005);
      assert((vector[0] + 0.0898).abs < 0.0005 && (vector[1] - 0.7126).abs < 0.0005 || (vector[0] - 0.0898).abs < 0.0005 && (vector[1] + 0.7126).abs < 0.0005)
    end
  end
end
